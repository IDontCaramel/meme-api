import express from 'express';
import fs from 'fs';
import path from 'path';
import { createCanvas, loadImage, registerFont } from 'canvas';
import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = 3000;

// directories
const directory1 = 'images';
const directory2 = 'premade';

// randomly select a directory
function getRandomDirectory() {
    return Math.random() < 0.5 ? directory1 : directory2;
}

// function to add text to the image
async function addTextToImage(imagePath, topText, bottomText, fontPath, fontName) {
    registerFont(fontPath, { family: fontName });

    const image = await loadImage(imagePath);
    const canvas = createCanvas(image.width, image.height);
    const ctx = canvas.getContext('2d');

    ctx.drawImage(image, 0, 0, image.width, image.height);

    const textColor = 'white';
    const strokeColor = 'black';
    const fontSize = Math.floor(image.height / 15);
    ctx.font = `${fontSize}px ${fontName}`;
    ctx.textAlign = 'center';
    ctx.fillStyle = textColor;
    ctx.strokeStyle = strokeColor;
    ctx.lineWidth = fontSize / 10;

    function wrapText(context, text, maxWidth) {
        const words = text.split(' ');
        let lines = [];
        let currentLine = '';

        for (let word of words) {
            const testLine = currentLine + word + ' ';
            const metrics = context.measureText(testLine);
            if (metrics.width > maxWidth && currentLine) {
                lines.push(currentLine.trim());
                currentLine = word + ' ';
            } else {
                currentLine = testLine;
            }
        }
        lines.push(currentLine.trim());
        return lines;
    }

    const topLines = wrapText(ctx, topText, image.width * 0.9);
    topLines.forEach((line, index) => {
        const yPos = fontSize * (index + 1);
        ctx.strokeText(line, image.width / 2, yPos);
        ctx.fillText(line, image.width / 2, yPos);
    });

    const bottomLines = wrapText(ctx, bottomText, image.width * 0.9);
    bottomLines.reverse().forEach((line, index) => {
        const yPos = image.height - fontSize * (index + 1);
        ctx.strokeText(line, image.width / 2, yPos);
        ctx.fillText(line, image.width / 2, yPos);
    });

    return canvas.toDataURL('image/png').split(',')[1];
}

const _fontName = 'impact';
const _fontPath = 'fonts/impact.ttf';

// initialize OpenAI with your API key
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// function for getting a rndm quote from openai API
async function generateMemeQuote() {
    try {
        const completion = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a helpful assistant." },
                {
                    role: "user",
                    content:
                        "Write a unhinged and funny meme quote and needs to be short, it can have 2 parts max which should be separated by a comma. If needed to use swear words replace them with 'frick' or 'fricking' please refrain from saying wich part 1 or part 2",
                },
            ],
        });

        // get and parse returned content
        let response = completion.choices[0].message.content;

        // "advanced anti openai censorship"
        response = response.replace(/\bfrick\b|frick(?=\w)/gi, "fuck");

        // make list from response
        const splitResponse = response
            .split(",")
            .map((part) => part.trim().replace(/^"|"$/g, ""));

        return splitResponse;
    } catch (error) {
        console.error("Error generating meme quote:", error);
        return [];
    }
}

// API endpoint
app.post('/process-random', async (req, res) => {
    try {
        const selectedDirectory = getRandomDirectory();
        const files = fs.readdirSync(selectedDirectory);

        if (files.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No files in the selected directory.'
            });
        }

        const randomFile = files[Math.floor(Math.random() * files.length)];
        const filePath = path.join(selectedDirectory, randomFile);

        let base64Image;

        if (selectedDirectory === directory1) {
            const memeQuote = await generateMemeQuote();

            console.log(`${memeQuote[0]} - ${memeQuote[1]}`)

            if (memeQuote.length >= 2) {
                base64Image = await addTextToImage(filePath, memeQuote[0], memeQuote[1], _fontPath, _fontName);
            } else if (memeQuote.length == 1) {
                base64Image = await addTextToImage(filePath, memeQuote[0], '', _fontPath, _fontName);
            } else {
                base64Image = await addTextToImage(filePath, '', '', _fontPath, _fontName);
            }

        } else {
            base64Image = fs.readFileSync(filePath).toString('base64');
        }

        // send the base64 encoded image as response
        res.json({
            success: true,
            base64Image: base64Image
        });
    } catch (error) {
        console.error('Error processing the random file:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to process the random image.'
        });
    }
});

// start API
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
