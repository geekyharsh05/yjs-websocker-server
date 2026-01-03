# Y-WebSocket Server Deployment Guide

## 🚀 Local Testing

### 1. Start the containers
```bash
docker compose up --build
```

### 2. Test the WebSocket connection
Open `test.html` in your browser (or multiple browsers/tabs) to test real-time collaboration:
```bash
open test.html
```

The test page will connect to `ws://localhost:1234` and demonstrate:
- Real-time text synchronization across multiple clients
- Connection status monitoring
- LevelDB persistence (data survives restarts)

### 3. Verify persistence
1. Type something in the test page
2. Stop the containers: `docker compose down`
3. Start again: `docker compose up`
4. Reload the test page - your data should still be there!

## 🌐 VPS Deployment

### 1. Update the Caddyfile
Edit `Caddyfile` and replace the placeholder with your domain:

```
yourdomain.com {
    reverse_proxy y-websocket:1234
}
```

### 2. Deploy on your VPS
```bash
# Copy files to VPS
scp -r . user@your-vps-ip:/path/to/app

# SSH into VPS
ssh user@your-vps-ip

# Navigate to directory
cd /path/to/app

# Start services
docker compose up -d
```

### 3. Update your client code
```javascript
const wsProvider = new WebsocketProvider(
    'wss://yourdomain.com',  // Use wss:// for secure WebSocket
    'my-roomname',
    doc
)
```

## 📦 What's Included

- **y-websocket service**: WebSocket server with LevelDB persistence
- **caddy service**: Reverse proxy with automatic HTTPS
- **Persistent volumes**: 
  - `y-websocket-data`: Stores LevelDB database
  - `caddy_data` & `caddy_config`: Stores Caddy data and SSL certificates

## 🔧 Configuration

### Environment Variables
See `.env.example` for all available configuration options.

### Custom Port
To change the port, update both:
1. `compose.yml`: Update the `ports` section in the caddy service
2. `Caddyfile`: Update the `:1234` directive

## 🛠️ Useful Commands

```bash
# Start in background
docker compose up -d

# View logs
docker compose logs -f

# View only y-websocket logs
docker compose logs -f y-websocket

# Stop containers
docker compose down

# Stop and remove volumes (⚠️ deletes all data)
docker compose down -v

# Rebuild after code changes
docker compose up --build
```

## 📊 Monitoring

Check if the server is running:
```bash
curl http://localhost:1234
# Should return: okay
```

Test WebSocket with wscat:
```bash
npm install -g wscat
wscat -c ws://localhost:1234/test-room
```

## 🔒 Security Notes for Production

1. **Enable HTTPS**: Caddy automatically handles SSL certificates for your domain
2. **Authentication**: Consider implementing authentication in `src/server.js` (see comments in the code)
3. **Firewall**: Only expose necessary ports (80, 443)
4. **Environment Variables**: Use proper secrets management for sensitive data
5. **Rate Limiting**: Consider adding rate limiting to Caddy configuration

## 📝 Next Steps

1. Test locally with `test.html`
2. Customize the Caddyfile for your domain
3. Deploy to your VPS
4. Integrate with your application using y-websocket client
