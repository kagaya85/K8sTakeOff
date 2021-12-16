# K8sTakeOff

## Environment requirement

* Linux Kernel 4.11+
* Enable iptables

## Version

* kubernetes v1.23.0
* pause v3.6
* ETCD v3.5.1-0
* Core DNS v1.8.6
* containerd v1.4.3 **or** docker
* calico v3.17 **or** cilium (recommended).

## How to use

Use this command when first execution:

```bash
chmod u+x K8sTakeOff/*.sh
```

Then config each script's variables as you expect and run it.

More Info is [Here](https://kagaya85.github.io/p/2020/%E4%BD%BF%E7%94%A8kubernetes-v1.20.0-%E4%B8%8E-containerd-%E9%85%8D%E7%BD%AEk8s%E9%9B%86%E7%BE%A4/) (Chinese)