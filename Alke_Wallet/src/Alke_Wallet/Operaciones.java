package Alke_Wallet;

//Contratos
public interface Operaciones {
    void depositar(double monto, String moneda);
    void retirar(double monto, String moneda);
    void convertirMoneda(String moneda2, String moneda);
}
