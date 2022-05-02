# k3s-automated-install
Simple script that automates the k3s install on multiple nodes

# Assumptions
* This assumes you've added your SSH public key from the PC you're running this script to all nodes
* Assumes you're installing on all clean nodes (no ~/.kube folder on nodes or the machine you're running the script on)
* Assumes you've added all node IP addresses to line 4 and line 5
* Assumes you've changed the username on line 3 to match that of the nodes
* Assumes you're running this on OS X, I've only tested this on OS X.  It *should* work on other distros with bash but I'm unsure on the sed command

# Usage

If you want to automate any kubectl commands you can do so at the bottom of the script.  I'm automatiaclly installing Tanzu Observability as an example

```
git clone .
cd k3s-automated-install
# Make changes according to the assumptions section
./createCluster.sh
```
