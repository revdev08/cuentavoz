import sharp from "sharp";

const source = "app/icon.svg";

await sharp(source, { density: 384 }).resize(192, 192).png().toFile("public/favicon-192.png");
await sharp(source, { density: 384 }).resize(180, 180).png().toFile("public/apple-touch-icon.png");

console.log("Íconos de marca generados en public/.");
