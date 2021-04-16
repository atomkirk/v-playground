module main

import vweb
import x.websocket

struct App {
	vweb.Context
pub mut:
	model Model
}

fn main() {
	vweb.run<App>(8082)
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) init_once() {
	go app.start_server()
}

struct Model {
mut:
	count int = 3
}

fn (mut app App) start_server() ? {
	mut s := websocket.new_server(30000, '')
	s.ping_interval = 100
	s.on_connect(fn (mut s websocket.ServerClient) ?bool {
		if s.resource_name != '/' {
			panic('unexpected resource name in test')
			return false
		}
		return true
	}) ?

	s.on_message_ref(fn (mut ws websocket.Client, msg &websocket.Message, mut model Model) ? {
		event := msg.payload.bytestr()

		model.update(event)

		rendered := model.view()

		ws.write(rendered.bytes(), msg.opcode) or { panic(err) }
	}, app.model)

	s.on_close(fn (mut ws websocket.Client, code int, reason string) ? {
		// not used
	})

	s.listen() or {}
}

fn (mut model Model) update(event string) {
	match event {
		'init' {
			model.count = 0
		}
		'inc' {
			model.count++
		}
		'dec' {
			model.count--
		}
		else {}
	}
}

fn (model Model) view() string {
	return '
		<div>$model.count</div>
		<button v-click="inc">+</button>
		<button v-click="dec">-</button>
	'
}
