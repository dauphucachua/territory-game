/// I do not claim authorship of this code. This was provided by Gemini as a solution to a CORS security error
/// in browsers when running the app post-deployment. The error was preventing the application from contacting the chatbot API.
/// AI use was suggested and approved by the supervisor of this project, as the error was not related to the application's 
/// design and was preventing the user testing phase from beginning.

const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const fetch = (...args) => import("node-fetch").then(({ default: fetch }) => fetch(...args));

const mistralKey = defineSecret("MISTRAL_API_KEY");

exports.mistralProxy = onRequest({
  cors: true, // Automatically attaches CORS headers for Flutter Web
  timeoutSeconds: 300, // Extends timeout to 5 minutes
  secrets: [mistralKey],
}, async (req, res) => {
  try {
    // Strip the local path and forward directly to Mistral's API
    const targetUrl = `https://api.mistral.ai${req.path}`;

    const response = await fetch(targetUrl, {
      method: req.method,
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${mistralKey.value()}`,
      },
      body: req.method !== "GET" ? JSON.stringify(req.body) : undefined,
    });

    const data = await response.json();
    res.status(response.status).json(data);
  } catch (err) {
    res.status(500).json({ error: "Proxy failed to reach Mistral API" });
  }
});