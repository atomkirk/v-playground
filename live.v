module main

import vweb
import x.websocket

struct App {
pub mut:
	vweb vweb.Context
  model &Model
}

fn main() {
	vweb.run<App>(8082)
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub fn (app &App) init() {
}

pub fn (mut app App) init_once() {
	go start_server(mut app)
}

struct Model {
  mut:
  count int
}

fn start_server(mut app App) ? {
	mut s := websocket.new_server(30000, '')
	// make that in execution test time give time to execute at least one time
	s.ping_interval = 100
	s.on_connect(fn (mut s websocket.ServerClient) ?bool {
		// here you can look att the client info and accept or not accept
		// just returning a true/false
		if s.resource_name != '/' {
			panic('unexpected resource name in test')
			return false
		}
		return true
	}) ?


	s.on_message_ref(fn (mut ws websocket.Client, msg &websocket.Message, mut model Model) ? {
    event := msg.payload.bytestr()
    println(event)

    // update(event, mut app.model)
    match event {
      'init' {
        model.count = 0
      }
      'inc' {
        model.count = model.count + 1
      }
      'dec' {
        model.count = model.count - 1
      }
      else {
      }
    }


    // rendered := view(model)
    rendered := '<div>$model.count</div>'

		ws.write(rendered.bytes(), msg.opcode) or { panic(err) }
	}, app.model)
	s.on_close(fn (mut ws websocket.Client, code int, reason string) ? {
		// not used
	})
	s.listen() or { }
}

fn update(event string, mut model Model) {
  match event {
    'init' {
      model.count = 0
    }
    'inc' {
      model.count = model.count + 1
    }
    'dec' {
      model.count = model.count - 1
    }
    else {
    }
  }
}

fn view(model Model) string {
  return '<div>$model.count</div>'
}
