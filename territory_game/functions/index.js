/// I do not claim authorship of this code. This was provided by Gemini as a solution to a CORS security error
/// in browsers when running the app post-deployment. The error was preventing the application from contacting the chatbot API.
/// AI use was suggested and approved by the supervisor of this project, as the error was not related to the application's 
/// design and was preventing the user testing phase from beginning.

const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");

const mistralApiKey = defineSecret("MISTRAL_API_KEY");

exports.mistralProxy = onRequest(
  {
    cors: true,
    timeoutSeconds: 300,
    secrets: [mistralApiKey],
  },
  async (req, res) => {
    try {
      const targetUrl = `https://api.mistral.ai${req.path}`;

      // Native Node 18/20 fetch
      const response = await fetch(targetUrl, {
        method: req.method,
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${mistralApiKey.value()}`,
        },
        body: req.method !== "GET" ? JSON.stringify(req.body) : undefined,
      });

      const data = await response.json();
      res.status(response.status).json(data);
    } catch (err) {
      res.status(500).json({ error: "Failed to proxy request to Mistral API" });
    }
  }
);