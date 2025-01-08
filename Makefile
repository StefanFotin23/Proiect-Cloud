# Variables
NAMESPACE=app
TERRAFORM_DIR=terraform
K8S_DIR=k8s

# Docker Images
IMAGES = frontend backend auth database
TAG = local

.PHONY: all build terraform-init terraform-apply k8s-apply start stop logs scale

# Default target
all: build terraform-apply k8s-apply

# Build Docker images locally
build:
	@echo "Building Docker images locally..."
	@for image in $(IMAGES); do \
	  docker build -t $$image:$(TAG) ./dockerfile/$$image; \
	done

# Initialize Terraform
terraform-init:
	@echo "Initializing Terraform..."
	cd $(TERRAFORM_DIR) && terraform init

# Apply Terraform configuration
terraform-apply:
	@echo "Applying Terraform configuration..."
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

# Deploy Kubernetes resources
k8s-apply:
	@echo "Deploying Kubernetes resources..."
	kubectl apply -f $(K8S_DIR)

# Start the entire flow
start: build terraform-init terraform-apply k8s-apply

# Stop the deployment
stop:
	@echo "Deleting Kubernetes namespace and destroying infrastructure..."
	kubectl delete namespace $(NAMESPACE)
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

# View logs for a specific pod
logs:
	@echo "Viewing logs for pod: $$POD_NAME in namespace: $(NAMESPACE)..."
	kubectl logs -n $(NAMESPACE) $$POD_NAME

# Scale a deployment
scale:
	@echo "Scaling deployment: $$DEPLOYMENT_NAME to $$REPLICAS replicas..."
	kubectl scale deployment $$DEPLOYMENT_NAME --replicas=$$REPLICAS -n $(NAMESPACE)
