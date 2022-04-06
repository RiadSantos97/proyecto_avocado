// SPDC-Licence-Identifier: GPL-3.0

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


    function crearCuenta(string calldata nombre, address payable direccion, uint fondos) public{
        Cuenta memory cuenta = Cuenta(
            nombre,
            direccion, 
            fondos
        );

        cuentas[cuenta.nombre] = cuenta;

        emit cuentaCreada(cuentas[cuenta.nombre].nombre, cuentas[cuenta.nombre].direccion, cuentas[cuenta.nombre].fondos);

    }

    event cuentaCreada(string nombre, address direccion, uint fondos);


    function transferencia (uint cantidad, string calldata nombreRemitente, string calldata nombreBeneficiario) public payable {
        require(cantidad > 0, "Debe realizar una transferencia con un valor mayor a cero");
        require(cuentas[nombreRemitente].fondos > msg.value, "No tiene los fondos suficientes para la transaccion");


    }

}