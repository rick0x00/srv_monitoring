# prometheus Server

Steps to Install And Configure

---

- System: Debian
- Container: Off
- Tool Engine: Shell Script

```bash
git clone https://github.com/rick0x00/srv_monitoring.git
cd srv_monitoring/technology/prometheus/os/debian/native/script
bash build_prometheus.sh
```

OR

```bash
wget https://raw.githubusercontent.com/rick0x00/srv_monitoring/master/technology/prometheus/os/debian/native/script/build_prometheus.sh -O /usr/local/src/build_prometheus.sh && bash /usr/local/src/build_prometheus.sh
```

OR

```bash
curl -fsSL https://raw.githubusercontent.com/rick0x00/srv_monitoring/master/technology/prometheus/os/debian/native/script/build_prometheus.sh | bash
```

OR

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rick0x00/srv_monitoring/master/technology/prometheus/os/debian/native/script/build_prometheus.sh)"
```

OR

```bash
bash -c "$(wget https://raw.githubusercontent.com/rick0x00/srv_monitoring/master/technology/prometheus/os/debian/native/script/build_prometheus.sh -O -)"
```