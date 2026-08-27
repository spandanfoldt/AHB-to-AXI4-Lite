# AHB-to-AXI4-Lite
It was originally part of a larger project I was working on with a team, but the project was discontinued after the initial idea. I haven’t worked on it since then, but I still think it’s a decent project and worth having on my GitHub.

## Architecture

The design follows a two-stage protocol conversion:

```text
AHB Master → AHB-to-AHB-Lite → AHB-Lite-to-AXI4-Lite → AXI4-Lite Slave
```

The **AHB-to-AHB-Lite** stage handles the conversion of AHB signals and transactions into the AHB-Lite interface. The **AHB-Lite-to-AXI4-Lite** stage then maps AHB-Lite read and write transactions onto the corresponding AXI4-Lite channels.

## Concepts

* AMBA AHB, AHB-Lite and AXI4-Lite protocols
* RTL protocol conversion
* FSM-based transaction control
* Read/write handshaking
* Synchronous digital design
* SystemVerilog RTL
