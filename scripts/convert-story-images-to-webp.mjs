import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import sharp from "sharp";

const [slug] = process.argv.slice(2);
const allowedExtensions = new Set([".png", ".jpg", ".jpeg", ".svg", ".gif", ".avif", ".tif", ".tiff"]);

if (!slug || !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug)) {
  console.error("Uso: npm run images:webp -- <slug-del-cuento>");
  process.exit(1);
}

const imagesRoot = path.resolve(process.cwd(), "public", "images");
const storyDirectory = path.resolve(imagesRoot, slug);

if (!storyDirectory.startsWith(`${imagesRoot}${path.sep}`)) {
  console.error("La carpeta indicada no es válida.");
  process.exit(1);
}

try {
  await fs.access(storyDirectory);
} catch {
  console.error(`No existe la carpeta: ${storyDirectory}`);
  process.exit(1);
}

const files = await fs.readdir(storyDirectory, { withFileTypes: true });
const sources = files
  .filter((file) => file.isFile() && allowedExtensions.has(path.extname(file.name).toLowerCase()))
  .map((file) => path.join(storyDirectory, file.name));

if (sources.length === 0) {
  console.log(`No hay imágenes pendientes de convertir en ${slug}.`);
  process.exit(0);
}

let converted = 0;
let removedOriginals = 0;
const failures = [];

for (const source of sources) {
  const extension = path.extname(source);
  const target = path.join(storyDirectory, `${path.basename(source, extension)}.webp`);
  const temporary = `${target}.${process.pid}.tmp.webp`;

  try {
    try {
      await fs.access(target);
      const existing = await sharp(target).metadata();
      if (existing.format !== "webp" || !existing.width || !existing.height) {
        throw new Error("El WebP existente no es válido.");
      }
    } catch (error) {
      if (error && error.code !== "ENOENT") throw error;

      const convertedBuffer = await sharp(source)
        .rotate()
        .webp({ quality: 82, effort: 5 })
        .toBuffer();

      const generated = await sharp(convertedBuffer).metadata();
      if (generated.format !== "webp" || !generated.width || !generated.height) {
        throw new Error("La conversión no produjo un WebP válido.");
      }

      await fs.writeFile(temporary, convertedBuffer);
      await fs.rename(temporary, target);
      converted += 1;
    }

    await fs.unlink(source);
    removedOriginals += 1;
    console.log(`✓ ${path.basename(source)} → ${path.basename(target)}`);
  } catch (error) {
    try {
      await fs.rm(temporary, { force: true });
    } catch {
      // El archivo fuente se conserva y el error de conversión se reporta abajo.
    }
    failures.push(`${path.basename(source)}: ${error instanceof Error ? error.message : String(error)}`);
  }
}

if (failures.length > 0) {
  console.error("\nNo se eliminaron los originales de las conversiones fallidas:");
  for (const failure of failures) console.error(`- ${failure}`);
  process.exitCode = 1;
} else {
  console.log(`\nListo: ${converted} WebP creados y ${removedOriginals} archivos originales eliminados.`);
}
