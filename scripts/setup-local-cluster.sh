#!/bin/bash#!/bin/bash#!/bin/bash



# setup-local-cluster.sh - Help set up local Kubernetes



echo "Local Kubernetes Setup Helper"# setup-local-cluster.sh - Help set up local Kubernetes# setup-local-cluster.sh - Automated local Kubernetes cluster setup

echo "============================="

# This script detects your system and guides you through setting up a local cluster

echo ""

echo "Checking system..."echo "Local Kubernetes Setup Helper"



if command -v brew &> /dev/null; thenecho "============================="set -e

    echo "Homebrew: installed"

    BREW_OK=true

else

    echo "Homebrew: not found"# Check systemecho "🚀 Local Kubernetes Cluster Setup"

    BREW_OK=false

fiecho ""echo "=================================="



if command -v docker &> /dev/null; thenecho "Checking system..."

    echo "Docker: installed"

    if docker info &> /dev/null; then# Colors for output

        echo "Docker: running"

    elseif command -v brew &> /dev/null; thenRED='\033[0;31m'

        echo "Docker: not running"

    fi    echo "Homebrew: installed"GREEN='\033[0;32m'

else

    echo "Docker: not installed"    BREW_OK=trueYELLOW='\033[1;33m'

fi

elseBLUE='\033[0;34m'

if command -v kubectl &> /dev/null; then

    echo "kubectl: installed"    echo "Homebrew: not found"NC='\033[0m' # No Color

else

    echo "kubectl: not installed"    BREW_OK=false

fi

fi# Function to print colored output

if command -v minikube &> /dev/null; then

    echo "Minikube: installed"print_status() {

    MINIKUBE_OK=true

elseif command -v docker &> /dev/null; then    echo -e "${GREEN}✅ $1${NC}"

    echo "Minikube: not installed"

    MINIKUBE_OK=false    echo "Docker: installed"}

fi

    if docker info &> /dev/null; then

if command -v kind &> /dev/null; then

    echo "Kind: installed"        echo "Docker: running"print_warning() {

    KIND_OK=true

else    else    echo -e "${YELLOW}⚠️  $1${NC}"

    echo "Kind: not installed" 

    KIND_OK=false        echo "Docker: not running"}

fi

    fi

echo ""

echo "Recommendations:"elseprint_error() {



if [[ "$BREW_OK" == true ]]; then    echo "Docker: not installed"    echo -e "${RED}❌ $1${NC}"

    echo ""

    echo "Install options via Homebrew:"fi}

    echo "  brew install minikube"

    echo "  brew install kind"

    echo "  brew install --cask docker"

fiif command -v kubectl &> /dev/null; thenprint_info() {



echo ""    echo "kubectl: installed"    echo -e "${BLUE}ℹ️  $1${NC}"

echo "Manual install options:"

echo "- Docker Desktop: https://www.docker.com/products/docker-desktop/"else}

echo "- Minikube: https://minikube.sigs.k8s.io/docs/start/"

echo "- Kind: https://kind.sigs.k8s.io/docs/user/quick-start/"    echo "kubectl: not installed"



# Interactive setupfi# Check if running on macOS

if [[ "$MINIKUBE_OK" == true ]]; then

    echo ""if [[ "$OSTYPE" != "darwin"* ]]; then

    read -p "Start Minikube now? (y/n): " -n 1 -r

    echoif command -v minikube &> /dev/null; then    print_warning "This script is optimized for macOS. Some commands may need adjustment for other systems."

    if [[ $REPLY =~ ^[Yy]$ ]]; then

        minikube start    echo "Minikube: installed"fi

        echo "Ready to deploy!"

        exit 0    MINIKUBE_OK=true

    fi

fielseecho ""



if [[ "$KIND_OK" == true ]]; then    echo "Minikube: not installed"echo "🔍 Checking your system..."

    echo ""

    read -p "Create Kind cluster? (y/n): " -n 1 -r    MINIKUBE_OK=false

    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; thenfi# Check if Homebrew is available

        kind create cluster --name httpbin-test

        echo "Ready to deploy!"if command -v brew &> /dev/null; then

        exit 0

    fiif command -v kind &> /dev/null; then    print_status "Homebrew is installed"

fi

    echo "Kind: installed"    BREW_AVAILABLE=true

echo ""

echo "Next steps:"    KIND_OK=trueelse

echo "1. Install a local Kubernetes option above"

echo "2. Verify: kubectl cluster-info"else    print_warning "Homebrew not found. You may need to install tools manually."

echo "3. Deploy: ./scripts/deploy.sh"
    echo "Kind: not installed"     BREW_AVAILABLE=false

    KIND_OK=falsefi

fi

# Check if Docker is installed

echo ""if command -v docker &> /dev/null; then

echo "Recommendations:"    print_status "Docker is installed"

    DOCKER_AVAILABLE=true

if [[ "$BREW_OK" == true ]]; then    

    echo ""    # Check if Docker is running

    echo "Install options via Homebrew:"    if docker info &> /dev/null; then

    echo "  brew install minikube"        print_status "Docker is running"

    echo "  brew install kind"        DOCKER_RUNNING=true

    echo "  brew install --cask docker"    else

fi        print_warning "Docker is installed but not running"

        DOCKER_RUNNING=false

echo ""    fi

echo "Manual install options:"else

echo "- Docker Desktop: https://www.docker.com/products/docker-desktop/"    print_error "Docker is not installed"

echo "- Minikube: https://minikube.sigs.k8s.io/docs/start/"    DOCKER_AVAILABLE=false

echo "- Kind: https://kind.sigs.k8s.io/docs/user/quick-start/"    DOCKER_RUNNING=false

fi

# Interactive setup

if [[ "$MINIKUBE_OK" == true ]]; then# Check if kubectl is installed

    echo ""if command -v kubectl &> /dev/null; then

    read -p "Start Minikube now? (y/n): " -n 1 -r    print_status "kubectl is installed"

    echo    KUBECTL_AVAILABLE=true

    if [[ $REPLY =~ ^[Yy]$ ]]; thenelse

        minikube start    print_error "kubectl is not installed"

        echo "Ready to deploy!"    KUBECTL_AVAILABLE=false

        exit 0fi

    fi

fi# Check if any local cluster tools are available

MINIKUBE_AVAILABLE=false

if [[ "$KIND_OK" == true ]]; thenKIND_AVAILABLE=false

    echo ""K3S_AVAILABLE=false

    read -p "Create Kind cluster? (y/n): " -n 1 -r

    echoif command -v minikube &> /dev/null; then

    if [[ $REPLY =~ ^[Yy]$ ]]; then    print_status "Minikube is installed"

        kind create cluster --name httpbin-test    MINIKUBE_AVAILABLE=true

        echo "Ready to deploy!"fi

        exit 0

    fiif command -v kind &> /dev/null; then

fi    print_status "Kind is installed"

    KIND_AVAILABLE=true

echo ""fi

echo "Next steps:"

echo "1. Install a local Kubernetes option above"if command -v k3s &> /dev/null; then

echo "2. Verify: kubectl cluster-info"    print_status "k3s is installed"

echo "3. Deploy: ./scripts/deploy.sh"    K3S_AVAILABLE=true
fi

echo ""
echo "📋 Recommendations based on your system:"
echo "========================================"

# Recommend best option based on what's available
if [[ "$DOCKER_AVAILABLE" == true && "$DOCKER_RUNNING" == true ]]; then
    echo ""
    print_info "RECOMMENDED: Docker Desktop with Kubernetes"
    echo "   Docker is running. Enable Kubernetes in Docker Desktop:"
    echo "   1. Open Docker Desktop"
    echo "   2. Go to Settings → Kubernetes"
    echo "   3. Check 'Enable Kubernetes'"
    echo "   4. Click 'Apply & Restart'"
    echo ""
    
    if ! kubectl cluster-info &> /dev/null; then
        echo "   After enabling Kubernetes in Docker Desktop, run:"
        echo "   kubectl cluster-info"
    else
        print_status "Kubernetes cluster is already running!"
        echo ""
        echo "🎉 You're ready to deploy! Run:"
        echo "   ./scripts/deploy.sh"
        exit 0
    fi
    
elif [[ "$DOCKER_AVAILABLE" == true ]]; then
    echo ""
    print_info "Docker is installed but not running"
    echo "   Start Docker Desktop and then enable Kubernetes as described above"
    echo ""
fi

# Alternative recommendations
echo ""
echo "🔧 Alternative Options:"
echo "======================"

if [[ "$BREW_AVAILABLE" == true ]]; then
    echo ""
    print_info "Option 1: Install Minikube (Easy, full-featured)"
    echo "   brew install minikube"
    echo "   minikube start"
    echo ""
    
    print_info "Option 2: Install Kind (Lightweight, fast)"
    echo "   brew install kind"
    echo "   kind create cluster --name httpbin-test"
    echo ""
    
    if [[ "$KUBECTL_AVAILABLE" == false ]]; then
        print_info "Also install kubectl:"
        echo "   brew install kubectl"
        echo ""
    fi
else
    echo ""
    print_info "Manual Installation Options:"
    echo ""
    print_info "Option 1: Docker Desktop"
    echo "   Download from: https://www.docker.com/products/docker-desktop/"
    echo ""
    
    print_info "Option 2: Minikube"
    echo "   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64"
    echo "   sudo install minikube-darwin-amd64 /usr/local/bin/minikube"
    echo ""
    
    print_info "Option 3: Kind"
    echo "   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-darwin-amd64"
    echo "   chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind"
    echo ""
fi

# Interactive setup if tools are available
echo ""
echo "🤖 Interactive Setup:"
echo "===================="

if [[ "$MINIKUBE_AVAILABLE" == true ]]; then
    echo ""
    read -p "Would you like to start Minikube now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Starting Minikube..."
        minikube start
        if [ $? -eq 0 ]; then
            print_status "Minikube started successfully!"
            echo ""
            echo "🎉 You're ready to deploy! Run:"
            echo "   ./scripts/deploy.sh"
            exit 0
        else
            print_error "Failed to start Minikube"
        fi
    fi
fi

if [[ "$KIND_AVAILABLE" == true ]]; then
    echo ""
    read -p "Would you like to create a Kind cluster now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating Kind cluster..."
        kind create cluster --name httpbin-test
        if [ $? -eq 0 ]; then
            print_status "Kind cluster created successfully!"
            echo ""
            echo "🎉 You're ready to deploy! Run:"
            echo "   ./scripts/deploy.sh"
            exit 0
        else
            print_error "Failed to create Kind cluster"
        fi
    fi
fi

echo ""
echo "📚 Next Steps:"
echo "============="
echo "1. Choose and install one of the recommended options above"
echo "2. Verify your cluster: kubectl cluster-info"
echo "3. Deploy HTTPBin: ./scripts/deploy.sh"
echo "4. Test the deployment: ./scripts/verify.sh"
echo ""
echo "💡 For detailed instructions, see: LOCAL_SETUP.md"