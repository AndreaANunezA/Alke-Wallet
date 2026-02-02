package Alke_Wallet;

public class Wallet implements Operaciones {
	protected double saldo;
	protected double saldo2;
	protected String moneda;

    // Constructor
    public Wallet(double saldoInicial, String monedaInicial) {
        this.saldo = saldoInicial;
        this.moneda = monedaInicial;
    }

 // --- Métodos Getter ---
    public double getSaldo() {
        return this.saldo;
    }

    public String getMoneda() {
        return this.moneda;
    }
    
    // Ver saldo disponible 
    public void mostrarInformacion() {
        System.out.println("--- Estado de la Cuenta ---");
        //if(this.moneda == "CLP") {
        	
        //}
        System.out.println("Saldo actual: " + saldo + " " + moneda);
    }

    @Override
    public void depositar(double monto, String moneda) {
        if (monto > 0) {
        	this.saldo += monto;
            System.out.println("Su depósito de: " + monto + " " + moneda + " se ha realizado con éxito");
        }
    }

    @Override
    public void retirar(double monto, String moneda) {
        if (monto <= saldo && monto > 0) {
        	this.saldo -= monto;
            System.out.println("Su retiro de: " + monto + " " + moneda + " se ha realizado con éxito");
        } else {
            System.out.println("Saldo insuficiente o monto inválido.");
        }
    }

    @Override
    public void convertirMoneda(String moneda2, String moneda) {
        // Se deja USD como moneda base para la conversión
        double saldoUSD = 0;
        double saldoant = saldo;
        
        // Convertir a USD
        if (moneda.equals("USD")) 
        	saldoUSD = saldo;			// 1 = 1
        else if (moneda.equals("CLP")) 
        	saldoUSD = saldo / 865.8; // 1 USD = 865.8 CLP
        else if (moneda.equals("EUR")) 
        	saldoUSD = saldo / 0.85; // 1 USD = 0.85 EUR

        // Convertir de USD a moneda2, 
        if (moneda2.equals("USD")) 
        	this.saldo = saldoUSD;
        else if (moneda2.equals("CLP")) 
        	this.saldo = saldoUSD * 865.8;
        else if (moneda2.equals("EUR")) 
        	this.saldo = saldoUSD * 0.85;

        this.moneda = moneda2;
        // Redondear el saldo
        this.saldo = Math.round(saldo * 100.0) / 100.0;

        System.out.println("Se convirtió su saldo " + saldoant + " " + moneda + " a " + this.saldo + " " + moneda2);
        this.moneda = moneda2;
    }
}
