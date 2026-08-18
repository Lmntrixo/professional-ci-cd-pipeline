const express = require('express');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// SÉCURITÉ : Ajout des en-têtes HTTP sécurisés (Protection XSS, Clickjacking, etc.)
app.use(helmet());
app.use(express.json());

// EN-POINT STANDARD PRODUCTION : Utilisé par AWS ou Kubernetes pour vérifier que l'app est en vie
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'UP',deployment: 'Automated via SSM', timestamp: new Date() });
});

// SIMULATION RGPD (GDPR) : Gestion conforme des données personnelles
app.post('/api/v1/user-data', (req, res) => {
    // Les logs de production ne doivent JAMAIS afficher de données sensibles (PII)
    console.log("Audit logs: Requests received for data processing. [PII Redacted]");

    res.status(200).json({
        message: "Data processed successfully in compliance with GDPR.",
        storage_region: "eu-central-1 (Frankfurt)"
    });
});

app.listen(PORT, () => {
    console.log(`Application start and safely running on port ${PORT}`);
});
