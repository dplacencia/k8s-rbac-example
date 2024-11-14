#!/bin/bash
set -e

echo "Running tests..."
print_stars() {
    local length=${1:-14}  # Default to 14 if no argument provided
    printf '%*s\n' "$length" | tr ' ' '*'
}

# Test Developer Role in Staging Namespace (Expected: Success)
print_stars
echo "Testing developer access in staging namespace..."
if kubectl auth can-i create pods -n staging --as=developer; then
  echo "Developer can create pods in staging - PASSED"
else
  echo "Developer should have access in staging but doesn't - FAILED"
  exit 1
fi

# Test Developer Role in Production Namespace (Expected: Fail)
print_stars
echo "Testing developer access in production namespace..."
if kubectl auth can-i create pods -n production --as=developer; then
  echo "Developer should not have access in production - FAILED"
  exit 1
else
  echo "Developer is denied access in production as expected - PASSED"
fi

# Test Admin Role in Staging Namespace (Expected: Success)
print_stars
echo "Testing admin access in staging namespace..."
if kubectl auth can-i create pods -n staging --as=admin; then
  echo "Admin can create pods in staging - PASSED"
else
  echo "Admin should have access in staging but doesn't - FAILED"
  exit 1
fi

# Test Admin Role in Production Namespace (Expected: Success)
print_stars
echo "Testing admin access in production namespace..."
if kubectl auth can-i create pods -n production --as=admin; then
  echo "Admin can create pods in production - PASSED"
else
  echo "Admin should have access in production but doesn't - FAILED"
  exit 1
fi

print_stars
echo "All tests passed successfully!"
