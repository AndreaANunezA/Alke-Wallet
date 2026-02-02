package Alke_Wallet;

import static org.junit.jupiter.api.Assertions.*; 
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class WalletTest {
    private Wallet wallet;
    private WalletJoven walletJoven;

    @BeforeEach
    void setUp() {

        wallet = new Wallet(0, "USD");
        walletJoven = new WalletJoven(1000.0, "USD"); 
    }

    // --- PRUEBA DE DEPÓSITO ---
    @Test
    void testDepositarAumentaSaldo() {
        wallet.depositar(500.0, "USD");
        assertEquals(500.0, wallet.saldo, "El saldo debería ser 500");
    }

    // --- PRUEBA DE RETIRO NORMAL ---
    @Test
    void testRetirarMontoValido() {
        wallet.depositar(1000.0, "USD");
        wallet.retirar(300.0, "USD");
        assertEquals(700.0, wallet.saldo, "El saldo restante debería ser 700");
    }

    @Test
    void testRetirarSinSaldoSuficiente() {
        wallet.retirar(500.0, "USD");
        assertEquals(0.0, wallet.saldo, "El saldo no debe quedar negativo");
    }

    // --- PRUEBAS DE WALLET JOVEN (HERENCIA) ---
    @Test
    void testRetirarJovenExito() {
        // Saldo 1000, el límite es 500, intenta retirar 400 (es menor a la mitad)
        walletJoven.retirar(400.0, "USD");
        assertEquals(600.0, walletJoven.saldo, "Debería permitir el retiro");
    }

    @Test
    void testRetirarJovenFallaPorLimite() {
        // Saldo 1000, el límite es 500. Intenta retirar 501
        walletJoven.retirar(501.0, "USD");
        assertEquals(1000.0, walletJoven.saldo, "No debe permitir retirar más del 50% del saldo");
    }

    // --- PRUEBAS DE CONVERSIÓN ---
    @Test
    void testConvertirCLPaUSD() {
        Wallet walletCLP = new Wallet(8658.0, "CLP");
        walletCLP.convertirMoneda("USD", "CLP");
        assertEquals(10.0, walletCLP.saldo, 0.01, "La conversión a USD falló");
    }

    @Test
    void testConvertirUSDaEUR() {
        wallet.depositar(100.0, "USD");
        wallet.convertirMoneda("EUR", "USD");
        assertEquals(85.0, wallet.saldo, 0.01, "La conversión a EUR falló");
    }

    @Test
    void testCambioDeNombreDeMoneda() {
        wallet.convertirMoneda("CLP", "USD");
        assertEquals("CLP", wallet.moneda, "El nombre de la moneda debería actualizarse");
    }

}