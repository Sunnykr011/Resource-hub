# Create a new folder and enter it
mkdir nightvault
cd nightvault

# Create README.md
cat > README.md << 'EOF'
# NightVault

Simple RAM disk and cloud sync automation tool for Parrot OS.

## Usage
1. Edit ~/.vault.env with your MEGA credentials
2. Run the script: bash nightvault.sh
3. Use commands:
   - ~/nightvault/bin/snapshot.sh  # to save state
   - ~/nightvault/bin/recover.sh   # to restore from cloud
EOF

# Save your script
cat > nightvault.sh << 'EOF'
[PASTE YOUR ENTIRE SCRIPT HERE]
EOF

# Upload to GitHub
git init
git add README.md nightvault.sh
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/nightvault.git
git push -u origin main
