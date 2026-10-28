
const { onRequest } = require("firebase-functions/v2/https");

exports.testOpenAISetup = onRequest((req, res) => {
  res.json({
    success: true,
    mode: "mock",
    message: "Eat Better mock nutrition service is working!",
    meal: {
      name: "Grilled chicken with rice and vegetables",
      calories: 620,
      protein: 42,
      carbs: 58,
      fat: 20,
    },
  });
});
