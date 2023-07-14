title "Kubernetes Basics"

control "k8s-1.0" do
  impact 1.0
  title "Validate built-in namespaces"
  desc "The kube-system, kube-public, and default namespaces should exist"

  describe k8sobject(api: 'v1', type: 'namespaces', name: 'kube-system') do
    it { should exist }
  end

end