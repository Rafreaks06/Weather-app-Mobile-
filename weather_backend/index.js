require("dotenv").config(); // 1. Panggil dotenv paling atas
const express = require("express");
const axios = require("axios");
const cors = require("cors");

const app = express();
app.use(cors());

// 2. Ambil dari process.env
const API_KEY = process.env.API_KEY;
const PORT = process.env.PORT || 3001;

app.get("/weather", async (req, res) => {
  const city = req.query.city || "Tangerang";

  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${API_KEY}`
    );
    res.json(response.data);
  } catch (err) {
    res.status(500).json({ error: "Gagal ambil cuaca" });
  }
});

app.get("/forecast", async (req, res) => {
  const city = req.query.city || "Tangerang";

  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/forecast?q=${city}&units=metric&appid=${API_KEY}`
    );
    res.json(response.data);
  } catch (err) {
    res.status(500).json({ error: "Gagal ambil forecast" });
  }
});

app.listen(PORT, () => {
  console.log(`Backend jalan di http://localhost:${PORT}`);
});