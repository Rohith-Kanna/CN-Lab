# Experiment 10 — IEEE 802.3 Ethernet LAN (Fedora + Distrobox)

These files follow the supplied lab PDF: six nodes; 0.2Mb LAN bandwidth; default 20ms delay; TCP/FTP flow n0 -> n5 starting at 0.1s; TCP/FTP flow n1 -> n4 starting at 0.4s; simulation stops at 10s.

## Recommended Fedora route

On the Fedora host:

```bash
sudo dnf install distrobox podman
mkdir -p ~/CN-Lab/exp10
```

Copy `LAN.tcl` and `anal.awk` into `~/CN-Lab/exp10` on the host, then run:

```bash
distrobox create --name ns2lab --image ubuntu:24.04
distrobox enter ns2lab
sudo apt update
sudo apt install ns2 nam gawk -y
```

If `apt` cannot find packages, make sure Ubuntu's `universe` repository is enabled. Distrobox integrates the GUI with the host desktop, so NAM should be able to open a window.

## Verify and run

```bash
ns
```
At the `%` prompt, type `exit`.

Then:

```bash
cd ~/CN-Lab/exp10
ns LAN.tcl
```

The script generates delay-specific files such as `LAN_20ms.tr`, `LAN_20ms.nam`, and `metrics_20ms.txt`, and attempts to open NAM.

Skip NAM while testing:

```bash
ns LAN.tcl 20ms 0
```

Change only LAN delay (keep bandwidth at 0.2Mb) to compare performance:

```bash
ns LAN.tcl 10ms 0
ns LAN.tcl 20ms 0
ns LAN.tcl 40ms 0
ns LAN.tcl 60ms 0
ns LAN.tcl 80ms 0
```
Each delay uses a different filename, so results are preserved.

## Optional: generate a throughput-vs-delay CSV and graph

Run `bash run_sweep.sh` to simulate 10, 20, 40, 60, and 80 ms delays at a fixed 0.2Mb bandwidth. It creates `results.csv`. If `gnuplot` is installed in the container (`sudo apt install gnuplot -y`), the script also creates `throughput_vs_delay.png`.
