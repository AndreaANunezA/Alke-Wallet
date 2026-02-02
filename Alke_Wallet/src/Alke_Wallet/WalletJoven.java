package Alke_Wallet;

public class WalletJoven extends Wallet {
    public WalletJoven(double monto, String moneda) {
        super(monto, moneda); // Reutilizamos el constructor del padre
    }

    @Override
    public void retirar(double monto, String moneda) {
        double saldojoven = saldo / 2; // Se fija un retiro máximo, de la mitad del saldo
    	
        if (monto > saldojoven) {
            System.out.println("No puedes retirar más de " + saldojoven + " " + moneda + " por tener cuenta Joven");
        }      
        else if (monto > 0 && monto <= saldo) {
        	this.saldo -= monto; // Restamos del saldo heredado
            System.out.println("Su retiro Joven de: " + monto + " " + moneda + " se ha realizado con éxito");
        } else {
            System.out.println("Error: Saldo insuficiente.");
        }
    }
}
