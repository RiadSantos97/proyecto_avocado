// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Contrato {

    //mapping donde tendremos las cuentas creadas en el contrato
    mapping(string => Cuenta) public cuentas;

    //Este sirve como el molde para las cuentas
    struct Cuenta{
        string nombre;
        address payable direccion;
        uint fondos;
    }

    //Función para crear una nueva cuenta, la cual tendrá el nombre del propietario, su dirección y los fondos asignados
    //Se utiliza calldata debido a que estas variables solo serán almacenadas de forma temporal y se especifica que el address sea payable para asegurarnos que se puedan realizar transferencias
    function crearCuenta(string calldata nombre, address payable direccion) public{

        //Se crea la cuenta con los datos ingresados
        Cuenta memory cuenta = Cuenta(
            nombre,
            direccion,
            direccion.balance
        );

        //Se agrega la cuenta al map con el nombre del propietario de la cuenta como key
        cuentas[cuenta.nombre] = cuenta;

        //Se llama al evento de cuenta creada una vez ya se haya creado correctamente la cuenta
        emit cuentaCreada(cuentas[cuenta.nombre].nombre, cuentas[cuenta.nombre].direccion, cuentas[cuenta.nombre].fondos);

    }

    //Evento lanzado una vez se haya creado la cuenta correctamente
    event cuentaCreada(string nombre, address direccion, uint fondos);


    //Función para realizar la transferencia de una cuenta a otra
    function transferencia (string calldata nombreRemitente, string calldata nombreBeneficiario) public payable {
        /*
            Se revisa que la direccion del remitente sea la del sender para evitar problemas en la transacción.
            Se revisa que se esté intentando enviar una cantidad mayor a 0.
            Se revisa que el remitente tenga una cantidad mayor o igual de fondos a la cantidad a transferir
        */
        require(cuentas[nombreRemitente].direccion == msg.sender, "La direccion de remitente no es valida");
        require(msg.value > 0, "Debe realizar una transferencia con un valor mayor a cero");
        require(cuentas[nombreRemitente].fondos >= msg.value, "No tiene los fondos suficientes para la transaccion");

        //Se realiza la transferencia a la dirección del beneficiario y se actualizan los fondos en la cuenta
        cuentas[nombreBeneficiario].direccion.transfer(msg.value);
        cuentas[nombreBeneficiario].fondos += msg.value;

        //Se actualizan los fondos en la cuenta del remitente
        cuentas[nombreRemitente].fondos -= msg.value;

        //Se emite el evento de transderencia realizada una vez esta se haya realizado correctamente
        emit transferenciaRealizada(cuentas[nombreRemitente].nombre, cuentas[nombreBeneficiario].nombre, cuentas[nombreRemitente].fondos, cuentas[nombreBeneficiario].fondos, msg.value);
    }

    event transferenciaRealizada(string nombreRemitente, string nombreBeneficiario, uint fondosRemitente, uint fondosBeneficiario, uint cantidadTransferida);

    //Función para conseguir los fondos de la cuenta
    function getFondos(string calldata nombre) view public returns(uint){
        return cuentas[nombre].fondos;
    }
}