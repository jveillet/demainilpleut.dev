const { createCanvas, loadImage } = require('canvas');
const canvas = createCanvas(1200, 630);
const ctx = canvas.getContext('2d');
const fs = require('fs');
const { program } = require('commander');
const process = require('process');

program
    .version('1.0.0')
    .description('An application for generating OpenGraph images of posts')
    .requiredOption('-t, --title <title>', 'Title of the article')
    .requiredOption('-f, --filename <filename>', 'Opengraph image name')
    .requiredOption('-a, --author <name>', 'Author of the article')
    .requiredOption('-l, --labels <labels...>', 'Labels / tags of the article')
    .requiredOption('-d, --date <date>', 'Date of the article')
    .parse(process.argv);

const options = program.opts();

// Load the template image and generate the definitive OpenGraph image for the post.
loadImage('opengraph/opengraph_image.png').then((image) => {
    ctx.drawImage(image, 0, 0, 1200, 630);
    ctx.textBaseline = 'top';

    // Write the post title
    ctx.font = '48px Ubuntu, Arial, sans-serif';
    ctx.fillStyle = '#121212';
    wrapText(ctx, options.title, 50, 140, 1100, 80);

    // calculat the title heigt so the tags are positioned under
    const titleHeight = textHeight(ctx, options.title, 50, 140, 1100, 80);

    // Write the tag icon
    loadImage('src/images/icon-tag.svg').then((image) => {
        ctx.drawImage(image, 50, titleHeight + 10, 38, 38);
    });

    // Write the tags
    ctx.font = '32px Ubuntu, Arial, sans-serif';
    ctx.fillStyle = '#858585';
    let labels = options.labels.join(', ');
    ctx.fillText(labels, 95, titleHeight + 10);

    // Write the post author
    const authorName = `@${options.author}`;
    ctx.font = 'bold 20px Ubuntu, Arial, sans-serif';
    ctx.fillStyle = '#4d4d4d';
    ctx.fillText(authorName, 90, 538);

    // Write the post date
    ctx.font = '20px Ubuntu, Arial, sans-serif';
    ctx.fillStyle = '#4d4d4d';
    const authorMetrics = ctx.measureText(authorName);
    const dateString = options.date;
    const formatDate = (dateString) => {
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(dateString).toLocaleDateString(undefined, options);
    };
    ctx.fillText(`published on ${formatDate(dateString)}`, 110 + authorMetrics.width, 538);

    // Create the file in the right folder
    const out = fs.createWriteStream(options.filename);
    const stream = canvas.createPNGStream();
    stream.pipe(out);
    out.on('finish', () => console.log(`The OpenGraph image ${options.filename} was created.`));
    out.on('error', (e) => console.log(`[ERROR] The OpenGraph image ${options.filename} was not created. Message: ${e.message}`));
});

/**
 * Wrap the multiline text, ad reduce the font size if it is longer that a value.
 *
 * @param {NodeCanvasRenderingContext2D} context The canvas context.
 * @param {string} text The text to write inside the canvas.
 * @param {integer} x The position on the horyzontal axis.
 * @param {integer} y The position on the vertical axis.
 * @param {integer} maxWidth The max width that the text must not exceed.
 * @param {intger} lineHeight The line height.
 */
const wrapText = function(context, text, x, y, maxWidth, lineHeight) {
    text = truncate(text, 100);
    const words = text.split(' ');
    let line = '';

    for (let n = 0; n < words.length; n++) {
        let testLine = line + words[n] + ' ';
        let metrics = context.measureText(testLine);
        if (metrics.width > maxWidth && n > 0) {
            context.fillText(line, x, y);
            line = words[n] + ' ';
            y += lineHeight;
        } else {
            line = testLine;
        }
    }

    context.fillText(line, x, y);
};

/**
 * Calculate the height of a text.
 *
 * @param {NodeCanvasRenderingContext2D} context The canvas context.
 * @param {string} text The text to write inside the canvas.
 * @param {integer} x The position on the horyzontal axis.
 * @param {integer} y The position on the vertical axis.
 * @param {integer} maxWidth The max width that the text must not exceed.
 * @param {intger} lineHeight The line height.
 * @returns {integer} The y position (+ margin).
 */
const textHeight = function(context, text, x, y, maxWidth, lineHeight) {
    text = truncate(text, 100);
    const words = text.split(' ');
    let line = '';

    for (let n = 0; n < words.length; n++) {
        let testLine = line + words[n] + ' ';
        let metrics = context.measureText(testLine);
        if (metrics.width > maxWidth && n > 0) {
            line = words[n] + ' ';
            y += lineHeight;
        } else {
            line = testLine;
        }
    }

    return y + lineHeight;
};

/**
 * Truncte a text with a max lenght and add an ellipsys at the end.
 *
 * @param {string} str The text to truncate.
 * @param {integer} maxlength Maximum lengt of the text.
 * @returns {string} The truncated text or the original text.
 */
const truncate = function(str, maxlength) {
    return (str.length > maxlength) ?
        str.slice(0, maxlength - 3) + '…' : str;
};
