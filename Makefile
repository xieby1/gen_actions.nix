result: ./actions.nix
	nix-build $< -o $@

ymls: result
	for yml in $</*; do cp $$yml .github/workflows/; done
