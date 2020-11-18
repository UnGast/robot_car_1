import NvidiaJetsonGPIO

let controller = NvidiaJetsonGPIOController()

print(controller.headers)

print("GET STATE OF GPIO PIN", controller.getPinState(gpioId: 14))

print("SET STATE OF GPIO PIN")
try controller.set(gpioId: 14, direction: .input)
print("VALUE IS", controller.getValue(gpioId: 14))
//try controller.set(gpioId: , value: .high)