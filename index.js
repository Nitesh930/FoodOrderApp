const express = require('express');
const mongoose = require('mongoose');
const WebSocket = require('ws');
const schema = require('./schema'); // Your schema file
const app = express();
app.use(express.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/foodOrder', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected');
  
  // Send initial data to the client when connected
  sendItemNamesToClient(ws);

  ws.on('close', () => {
    console.log('Client disconnected');
  });
});

async function sendItemNamesToClient(ws) {
  try {
    const items = await schema.find({}, { ItemName: 1, price: 1, _id: 0 });
    ws.send(JSON.stringify(items));
  } catch (error) {
    console.error('Error sending item names:', error);
  }
}

app.post('/store', async (req, res) => {
  try {
    const data = new schema(req.body);
    await data.save();
    
    // Broadcast changes to all connected clients
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        sendItemNamesToClient(client);
      }
    });

    res.send(req.body);
    console.log('Saved and broadcasted!!');
  } catch (error) {
    console.error('Error saving item:', error);
    res.status(500).json({ message: 'Failed to save item' });
  }
});

app.delete('/delete', async (req, res) => {
  try {
    const { itemName } = req.body;
    if (!itemName) {
      return res.status(400).json({ message: 'Item name is required' });
    }

    const item = await schema.findOne({ ItemName: itemName });
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }

    await schema.deleteOne({ ItemName: itemName });

    // Broadcast changes to all connected clients
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        sendItemNamesToClient(client);
      }
    });

    res.status(200).json({ message: 'Item deleted successfully' });
  } catch (error) {
    console.error('Error deleting item:', error);
    res.status(500).json({ message: 'Failed to delete item' });
  }
});

app.listen(5000, () => {
  console.log("Server is running on port 5000");
});
