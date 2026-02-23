const express = require('express');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 8080;

// Serve the static files from the Flutter build folder
app.use(express.static(path.join(__dirname, 'build/web')));

// Route all other requests to index.html to support Flutter's path routing (e.g., go_router)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
