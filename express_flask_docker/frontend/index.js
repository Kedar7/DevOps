const express = require('express');
const path = require('path');
const fetch = global.fetch || require('node-fetch');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use('/public', express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'form.html'));
});

app.post('/submit', async (req, res) => {
  // Forward the form data to the Flask backend service (service name in docker-compose: backend)
  const backendUrl = process.env.BACKEND_URL || 'http://backend:5000/submit';
  try {
    const response = await fetch(backendUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams(req.body)
    });
    const data = await response.json();
    if (response.ok) {
      return res.redirect('/success');
    }
    return res.status(500).send(`Error from backend: ${data.error || JSON.stringify(data)}`);
  } catch (err) {
    return res.status(500).send(`Error forwarding to backend: ${err.message}`);
  }
});

app.get('/success', (req, res) => {
  res.send('<h1>Data submitted successfully</h1><p><a href="/">Back</a></p>');
});

app.listen(PORT, () => console.log(`Frontend listening on ${PORT}`));
