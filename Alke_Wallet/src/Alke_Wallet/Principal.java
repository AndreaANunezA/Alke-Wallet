package Alke_Wallet;

import java.util.Scanner;

public class Principal {
    public static void main(String[] args) {
        Scanner teclado = new Scanner(System.in);
        
        System.out.println("------------------------------------------------");
        System.out.println("----------- BIENVENIDO A ALKE WALLET -----------");
        System.out.println("------------------------------------------------");

        System.out.print("¿Qué moneda usará? (CLP, USD, EUR): ");
        String moneda = teclado.next().toUpperCase();

        System.out.println("Elija tipo de cuenta: 1.Normal  2.Joven");
        int tipo = teclado.nextInt();
        String tipo2 = "";
        
        if (tipo == 2) {
        	tipo2 = "Joven";
        }
        else {
        	tipo2 = "Normal";
        }
        		
        Wallet miCuentaWallet;

        // Crea el objeto según opción que se ingresa (Polimorfismo)
        if (tipo == 1) {
        	miCuentaWallet = new Wallet(0, moneda);
        }
        else if (tipo == 2) {
        	miCuentaWallet = new WalletJoven(0, moneda);
        }
        else miCuentaWallet = new Wallet(0, moneda); //Si ingresa otra opción usa por defecto la cuenta normal

        int opcion;
        do {
            System.out.println();
            System.out.println("-------------- MENÚ DE OPERACIONES -------------");
            System.out.println("--- Moneda inicial: " + moneda + " - Tipo cuenta: " + tipo2 + "---");
            System.out.println("------------------------------------------------");
            System.out.println("1. Ver saldo");
            System.out.println("2. Depositar");
            System.out.println("3. Retirar");
            System.out.println("4. Convertir moneda");
            System.out.println("5. Salir");
            System.out.println();
            System.out.println("Seleccione opción: ");
            opcion = teclado.nextInt();

            String otrasmonedas = "";
            
            if (opcion == 1) {
            	miCuentaWallet.mostrarInformacion(); 
            }
            else if (opcion == 2) {
                System.out.print("Monto a depositar: ");
                double dep = teclado.nextDouble();
                miCuentaWallet.depositar(dep, moneda); 
            }
            else if (opcion == 3) {
                System.out.print("Monto a retirar: ");
                double ret = teclado.nextDouble();
                miCuentaWallet.retirar(ret, moneda); 
	        }
            else if (opcion == 4) {
            	if(moneda.equals("CLP")){
            		otrasmonedas = "USD, EUR";
            	}
            	else if(moneda.equals("USD")){
            		otrasmonedas = "CLP, EUR";
            	}
            	else if(moneda.equals("EUR")){
            		otrasmonedas = "CLP, USD";
            	}
            	System.out.print("¿A qué moneda desea convertir?: " + otrasmonedas);             
	            String conv = teclado.next().toUpperCase();
	            miCuentaWallet.convertirMoneda(conv, moneda); 
	        }

        } while (opcion != 5);

        System.out.println("GRACIAS POR USAR ALKE WALLET");
        teclado.close();
    }
}
