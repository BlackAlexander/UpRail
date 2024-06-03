stop();

var cars: Array = new Array();
var carsChildren: Array = new Array();
var engineCount = 0;
var loadCount = 0;

function addNewCar(carIndex: int, carMass: int, carType: String, engineForce: Number, brakingForce: Number){
	if (carType != "load" && carType != "engine"){
		return;
	}
	if (carIndex < 0 || carMass < 0 || engineForce < 0 || brakingForce < 0){
		return;
	}
	if (carIndex > cars.length){
		return;
	}
	if (carType == "load"){
		loadCount++;
	} else {
		engineCount++;
	}
	if (carType == "load"){
		engineForce = 0;
		brakingForce = 0;
	}
	var newCar: Array = [carMass, carType, engineForce, brakingForce];
	cars.insertAt(carIndex, newCar);
}

function removeCarByIndex(carIndex: int){
	if (carIndex > cars.length){
		return;
	}
	var carToRemove = cars[carIndex];
	if (engineCount == 1 && carToRemove[1] == "engine"){
		return;
	}
	if (carToRemove[1] == "engine"){
		engineCount--;
	} else {
		loadCount--;
	}
	cars.removeAt(carIndex);
}

function clearPaintedCars(){
	for (var i: int = 0; i < carsChildren.length; i++){
		this.removeChild(carsChildren[i]);
	}
	carsChildren = [];
}

function paintCars(){
	for (var i: int = 0; i < cars.length; i++){
		var newCar;
		if (cars[i][1] == "engine"){
			newCar = new car_engine;
		} else {
			newCar = new car_load;
		}
		this.addChild(newCar);
		newCar.scaleX = 0.6;
		newCar.scaleY = 0.6;
		newCar.y = 0;
		newCar.x = -1*(cars.length/2)*70 + 35 + 70*(cars.length - i - 1);
		carsChildren.push(newCar);
	}
}

function updateCars(){
	clearPaintedCars();
	paintCars();
}

MovieClip(root).loadedUnits();