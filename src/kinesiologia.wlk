class Aparato {
	
	var property color= "blanco"
	
	method usado (paciente) {
		self.validarUso(paciente)
		self.efectoUsado(paciente)
	}
	
	method validarUso(paciente) {
		if(! self.puedeSerUsado(paciente)) {
			self.error("no puede ser usado por " + paciente)
		}
	}
	
	method puedeSerUsado(paciente)
	method efectoUsado(paciente)
}

class Magneto inherits Aparato {

	override method puedeSerUsado(paciente) {
		return true
	}

	override method usado(paciente) {
		paciente.curarDolor(paciente.dolor() * 0.1)
	}

}

class Bicicleta inherits Aparato {
	override method puedeSerUsado(paciente) {
		return !paciente.chiquito()
	}

	override method efectoUsado(paciente) {
		paciente.curarDolor(4)
		paciente.fortalecer(3)
	}
}

class Minitramp inherits Aparato  {
	override method puedeSerUsado(paciente) {
		return paciente.dolor() < 20
	}

	override method efectoUsado(paciente) {
		paciente.fortalecer(paciente.edad() * 0.1)
	}
}

class Paciente {

	var property fortaleza = 0
	var property dolor = 0
	var property edad = 0
	var rutina;

	method curarDolor(valor) {
		dolor -= valor
	}

	method fortalecer(valor) {
		fortaleza += valor
	}

	method chiquito() {
		return edad < 8
	}
	
	method puedeCumplirSesion() {
		return rutina.all({aparato => aparato.puedeSerUsado(self)})	
	}
	
	method puedeUsar(unAparato) {
		return unAparato.puedeSerUsado(self)
	}
	
	method sesion() {
		self.validarSesion()
		self.ejecutarSesion()	
	}
	
	method ejecutarSesion() {
		rutina.forEach({aparato => aparato.usado(self)})
	}
	
	method validarSesion() {
		if(!self.puedeCumplirSesion()) {
			self.error("Este paciente no puede cumplir la sesion")
		}
	}

}

class PacienteResistente inherits Paciente {
	
	override method ejecutarSesion() {
		super()
		self.fortalecer(rutina.size())
	}	
}

class PacienteCaprichoso inherits Paciente {
	
	
	override method puedeCumplirSesion() {
		return super() && rutina.any({aparato => aparato.color() == "rojo"})		
	}
	
	override method ejecutarSesion() {
		super()
		super()
	}		
}

object valorResistentes {
	var property valor = 3
}

class PacienteRapidaRecuperacion inherits Paciente {

	
	override method ejecutarSesion() {
		super()
		self.curarDolor(valorResistentes.valor())
	}		
}

class Centro {
	var pacientes
	var aparatos
	
	method colores() {
		return aparatos.map({aparato => aparato.color()}).asSet()
	}
	
	method pacientesChiquitos() {
		return pacientes.filter({paciente=> paciente.chiquito()})
	}
	
	method cuantosNoPuedenHacerSesion() {
		return pacientes.count({paciente=> ! paciente.puedeCumplirSesion()})		
	}
}