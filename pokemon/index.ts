import gameboy from './gameboy'
import { WebSocketServer } from 'ws'
import https from 'https'
import fs from 'fs'

type Controls = 'LEFT' | 'RIGHT' | 'UP' | 'DOWN' | 'A' | 'B' | 'SELECT' | 'START'

const server = https.createServer({
  key: fs.readFileSync('/etc/ssl/private/your-domain.key'),
  cert: fs.readFileSync('/etc/ssl/certs/your-domain.crt'),
});

const wss = new WebSocketServer({ server })

wss.on('connection', function connection(ws) {
  console.log('Client connected')
  
  ws.send("hello")
  
  setTimeout(() => {
    console.log("Starting game loop")
    gameboy.doFrame()
    gameboy.doFrame()
    gameboy.doFrame()
    ws.send(JSON.stringify("ready"))
  }, 100)

  ws.on('message', function message(data) {
    const controls = data.toString() as Controls
    if(controls) {
      gameboy.pressKey(controls)        
    }
  })

  ws.on('close', function close() {
    console.log('Client disconnected')
  })
})

server.listen(8080, () => {
  console.log('Secure WebSocket server running on wss://localhost:8080');
});
