import gameboy from './gameboy'
import { WebSocketServer } from 'ws'

type Controls = 'LEFT' | 'RIGHT' | 'UP' | 'DOWN' | 'A' | 'B' | 'SELECT' | 'START'

console.log("Server has started!")

const wss = new WebSocketServer({ port: 8080 })

wss.on('connection', function connection(ws) {
  console.log('Client connected')
  
  ws.send("hello")
  console.log("Sent hello to client")
  
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

console.log('WebSocket server running on ws://localhost:8080')
