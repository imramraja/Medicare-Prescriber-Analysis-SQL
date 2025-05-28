# Database setup script
$server = "RAMRAJA"
$database = "MedicarePartDAnalysis"

# Create database
sqlcmd -S $server -Q "CREATE DATABASE $database"

# Create tables
sqlcmd -S $server -U $user -P $password -d $database -i "..\sql\create_tables.sql"

# Create stored procedures
Get-ChildItem "..\sql\stored_procedures\" -Filter *.sql | ForEach-Object {
    sqlcmd -S $server -U $user -P $password -d $database -i $_.FullName
}

# Create functions
Get-ChildItem "..\sql\functions\" -Filter *.sql | ForEach-Object {
    sqlcmd -S $server -U $user -P $password -d $database -i $_.FullName
}

# Create views
Get-ChildItem "..\sql\views\" -Filter *.sql | ForEach-Object {
    sqlcmd -S $server -U $user -P $password -d $database -i $_.FullName
}

# Create triggers
Get-ChildItem "..\sql\triggers\" -Filter *.sql | ForEach-Object {
    sqlcmd -S $server -U $user -P $password -d $database -i $_.FullName
}

# Create indexes
Get-ChildItem "..\sql\indexes\" -Filter *.sql | ForEach-Object {
    sqlcmd -S $server -U $user -P $password -d $database -i $_.FullName
}

Write-Host "Database setup completed successfully" -ForegroundColor Green
