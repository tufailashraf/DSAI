// // Path to the TensorFlow.js model
// const modelPath = "model/model.json";

// // Load the TensorFlow.js model
// let model;
// async function loadModel() {
//     console.log("Loading model...");
//     model = await tf.loadGraphModel(modelPath);
//     console.log("Model loaded successfully!");
// }

// // Set up image upload and preview
// const imageUpload = document.getElementById("imageUpload");
// const canvas = document.getElementById("canvas");
// const ctx = canvas.getContext("2d");

// imageUpload.addEventListener("change", (event) => {
//     const file = event.target.files[0];
//     if (file) {
//         const reader = new FileReader();
//         reader.onload = (e) => {
//             const img = new Image();
//             img.onload = () => {
//                 canvas.width = img.width;
//                 canvas.height = img.height;
//                 ctx.drawImage(img, 0, 0, img.width, img.height);
//             };
//             img.src = e.target.result;
//         };
//         reader.readAsDataURL(file);
//     }
// });

// // Garbage detection logic
// const detectButton = document.getElementById("detectButton");
// detectButton.addEventListener("click", async () => {
//     if (!model) {
//         alert("Model not loaded yet. Please wait...");
//         return;
//     }

//     const imageData = tf.browser.fromPixels(canvas)
//         .resizeNearestNeighbor([224, 224]) // Resize to model's input shape
//         .toFloat()
//         .expandDims(0);

//     console.log("Running detection...");
//     const predictions = await model.executeAsync(imageData);

//     drawBoundingBoxes(predictions);
// });

// // Draw bounding boxes
// function drawBoundingBoxes(predictions) {
//     const [boxes, scores, classes] = predictions.map((tensor) => tensor.arraySync());
//     const threshold = 0.5; // Confidence threshold

//     ctx.clearRect(0, 0, canvas.width, canvas.height);
//     ctx.drawImage(document.getElementById("uploadedImage"), 0, 0);

//     scores.forEach((score, i) => {
//         if (score > threshold) {
//             const [y1, x1, y2, x2] = boxes[i];
//             const label = classes[i];
//             const confidence = (score * 100).toFixed(2);

//             // Draw bounding box
//             ctx.strokeStyle = "red";
//             ctx.lineWidth = 2;
//             ctx.strokeRect(x1 * canvas.width, y1 * canvas.height, (x2 - x1) * canvas.width, (y2 - y1) * canvas.height);

//             // Draw label
//             ctx.fillStyle = "red";
//             ctx.font = "16px Arial";
//             ctx.fillText(`${label} (${confidence}%)`, x1 * canvas.width, y1 * canvas.height - 5);
//         }
//     });

//     predictions.forEach((tensor) => tensor.dispose());
// }
 
// // Initialize model on page load
// loadModel();









// Path to the TensorFlow.js model
const modelPath = "model/model.json";

// Load the TensorFlow.js model
let model;
async function loadModel() {
    try {
        console.log("Loading model...");
        model = await tf.loadLayersModel(modelPath);

        // Manually set input shape if not specified
        model.inputShape = model.inputShape || [784];
        console.log("Model loaded successfully!");
    } catch (error) {
        console.error("Error loading model:", error);
        alert("Failed to load the model. Please ensure the model files are correct and served properly.");
    }
}

// Set up image upload and preview
const imageUpload = document.getElementById("imageUpload");
const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

imageUpload.addEventListener("change", (event) => {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                canvas.width = 28; // Resize for consistency with model input
                canvas.height = 28;
                ctx.drawImage(img, 0, 0, 28, 28);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
});

// Prediction logic
const detectButton = document.getElementById("detectButton");
detectButton.addEventListener("click", async () => {
    if (!model) {
        alert("Model not loaded yet. Please wait...");
        return;
    }

    // Preprocess the image
    const imageData = tf.browser.fromPixels(canvas, 1) // Get image data as grayscale
        .toFloat()
        .div(255.0) // Normalize pixel values
        .reshape([1, 784]); // Reshape to [1, 784] for model input

    console.log("Running prediction...");
    const predictions = model.predict(imageData);
    const predictedClass = predictions.argMax(1).dataSync()[0];

    displayPrediction(predictedClass);
});

// Display prediction result
function displayPrediction(predictedClass) {
    const resultElement = document.getElementById("result");
    resultElement.innerText = `Predicted Class: ${predictedClass}`;
    console.log(`Prediction complete. Class: ${predictedClass}`);
}

// Initialize model on page load
loadModel();
