# Install Kubernetes
#yum-config-manager --save --setopt=kubernetes.skip_if_unavailable=true
echo "[TASK 9] Install Kubernetes (kubeadm, kubelet and kubectl)"
echo "Run dnf upgrade"
dnf -y upgrade --refresh
dnf install -y kubeadm-1.25.0 kubelet-1.25.0 kubectl-1.25.0 --disableexcludes=kubernetes

# Start and Enable kubelet service
echo "[TASK 10] Enable and start kubelet service"
systemctl enable kubelet
systemctl start kubelet

# Install sshpass
echo "[TASK 11] Install sshpass"
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
rpm -i sshpass-1.09-4.el8.x86_64.rpm
sshpass -V

# Enable ssh password authentication
echo "[TASK 12] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd
# Set Root password
echo "[TASK 13] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file