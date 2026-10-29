
const { onRequest } = require("firebase-functions/v2/https");
const OpenAI = require("openai");

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

exports.testOpenAISetup = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Use POST." });
  }

  try {
    const { imageBase64, mimeType } = req.body || {};

    if (
      typeof imageBase64 !== "string" ||
      imageBase64.length === 0 ||
      !["image/jpeg", "image/png", "image/webp"].includes(mimeType)
    ) {
      return res.status(400).json({
        error: "A valid food photo is required.",
      });
    }

    // Safe local testing: return sample data without calling OpenAI.
    if (process.env.USE_MOCK_NUTRITION === "true") {
      return res.json({
        success: true,
        mode: "mock",
        meal: {
          name: "Chicken, rice & vegetables",
          calories: 620,
          protein: 42,
          carbs: 58,
          fat: 20,
        },
      });
    }

    // Real AI analysis runs only when mock mode is disabled.
    const response = await openai.responses.create({
      model: "gpt-4o-mini",
      input: [
        {
          role: "user",
          content: [
            {
              type: "input_text",
              text: `Analyze this food photo and estimate one meal's
nutrition. Return ONLY valid JSON with these fields:
name (string), calories (integer), protein (number in grams),
carbs (number in grams), fat (number in grams).
Estimate a reasonable portion size. Do not claim exact accuracy.`,
            },
            {
              type: "input_image",
              image_url: `data:${mimeType};base64,${imageBase64}`,
              detail: "low",
            },
          ],
        },
      ],
    });

    const meal = JSON.parse(response.output_text);

    if (
      typeof meal.name !== "string" ||
      !["calories", "protein", "carbs", "fat"].every(
        (key) =>
          typeof meal[key] === "number" &&
          Number.isFinite(meal[key]) &&
          meal[key] >= 0
      )
    ) {
      throw new Error("Invalid nutrition response.");
    }

    return res.json({
      success: true,
      mode: "ai",
      meal,
    });
  } catch (error) {
    console.error("Meal analysis failed:", error.message);

    return res.status(500).json({
      error: "Meal analysis failed. Please try again.",
    });
  }
});
