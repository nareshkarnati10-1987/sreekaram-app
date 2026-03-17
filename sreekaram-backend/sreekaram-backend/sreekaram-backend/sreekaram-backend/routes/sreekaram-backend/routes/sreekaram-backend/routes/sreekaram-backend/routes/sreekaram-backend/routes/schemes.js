const express = require('express');
const router = express.Router();

// Government schemes for Telangana farmers
const SCHEMES = [
  {
    id: 1,
    name: 'Rythu Bandhu',
    telugu_name: 'రైతు బంధు',
    description: 'Investment support of Rs. 10,000 per acre per year for farming',
    telugu_desc: 'వ్యవసాయ పానుకు ఎకరాకు రూ.10,000 సహాయం',
    eligibility: 'All land-owning farmers in Telangana',
    benefit: 'Rs. 10,000 per acre (Rs. 5,000 each for Kharif and Rabi)',
    apply_link: 'https://rythubandhu.telangana.gov.in',
    category: 'financial',
  },
  {
    id: 2,
    name: 'PM-KISAN',
    telugu_name: 'పీఎం-కిసాన్',
    description: 'Income support of Rs. 6,000 per year to farmer families',
    telugu_desc: 'రైతు కుటుంబాలకు సంవత్సరంకు రూ.6,000 ఆదాయ సహాయం',
    eligibility: 'All farmer families with cultivable land',
    benefit: 'Rs. 2,000 every 4 months (3 installments)',
    apply_link: 'https://pmkisan.gov.in',
    category: 'financial',
  },
  {
    id: 3,
    name: 'Fasal Bima Yojana',
    telugu_name: 'పంట బీమా యోజన',
    description: 'Crop insurance to protect farmers from natural calamities',
    telugu_desc: 'సహజ విపత్తుల నుండి రైతులను రక్షించే పంట బీమా',
    eligibility: 'All farmers with crop loans',
    benefit: 'Up to full sum insured for crop loss',
    apply_link: 'https://pmfby.gov.in',
    category: 'insurance',
  },
  {
    id: 4,
    name: 'Kisan Credit Card',
    telugu_name: 'కిసాన్ క్రెడిట్ కార్డు',
    description: 'Short-term credit needs for crop cultivation',
    telugu_desc: 'పంట సాగుకు ల్యునల్కాలిక రుణ సౌలభ్యం',
    eligibility: 'All farmers, tenant farmers, and sharecroppers',
    benefit: 'Flexible credit up to Rs. 3 lakh at 4% interest',
    apply_link: 'https://www.nabard.org/kisan-credit-card',
    category: 'credit',
  },
];

// Get all schemes
router.get('/', (req, res) => {
  const { category } = req.query;
  let schemes = SCHEMES;
  if (category) schemes = SCHEMES.filter(s => s.category === category);
  res.json({ success: true, data: schemes });
});

// Get scheme by ID
router.get('/:id', (req, res) => {
  const scheme = SCHEMES.find(s => s.id === parseInt(req.params.id));
  if (!scheme) return res.status(404).json({ error: 'Scheme not found' });
  res.json({ success: true, data: scheme });
});

module.exports = router;