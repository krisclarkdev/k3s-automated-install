# k3s-automated-install
Simple script that automates the k3s install on multiple nodes

# Assumptions
* This assumes you've added your SSH public key from the PC you're running this script to all nodes
* Assumes you're installing on all clean nodes (no ~/.kube folder on nodes or the machine you're running the script on)
* Assumes you've added all node IP addresses to line X and line Y

# Usage

```
git clone .
cd k3s-automated-install
# Make changes according to the assumptions section
./createCluster.sh
```
