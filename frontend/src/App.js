import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import '@/App.css';
import { WalletProvider } from '@/components/WalletContext';
import LandingPage from '@/components/LandingPage';
import Dashboard from '@/components/Dashboard';
import CreditPassport from '@/components/CreditPassport';
import Analytics from '@/components/Analytics';
import Roadmap from '@/components/Roadmap';
import Navigation from '@/components/Navigation';
import ZKVerification from '@/components/ZKVerification';
import ProofOfUniqueness from '@/components/ProofOfUniqueness';
import ZKBadgeDisplay from '@/components/ZKBadgeDisplay';
import Footer from '@/components/Footer';
import Testnet from '@/components/Testnet';
import Premium from '@/components/Premium';
import MintBadge from '@/components/MintBadge';
import VerifyIdentity from '@/components/VerifyIdentity';
import AdminMonitoring from '@/components/AdminMonitoring';
import Waitlist from '@/components/Waitlist';
import AdminWaitlist from '@/components/AdminWaitlist';
import DirectMint from '@/components/DirectMint';
import ProofOfHumanity from '@/components/ProofOfHumanity';

function App() {
  return (
    <WalletProvider>
      <div className="App min-h-screen bg-gradient-to-br from-slate-950 via-purple-950 to-slate-950">
        <BrowserRouter>
          <Navigation />
          <Routes>
            <Route path="/" element={<LandingPage />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/passport" element={<CreditPassport />} />
            <Route path="/analytics" element={<Analytics />} />
            <Route path="/roadmap" element={<Roadmap />} />
            <Route path="/zk-verification" element={<ZKVerification />} />
            <Route path="/proof-uniqueness" element={<ProofOfUniqueness />} />
            <Route path="/zk-badges" element={<ZKBadgeDisplay />} />
            <Route path="/premium" element={<Premium />} />
            <Route path="/testnet" element={<Testnet />} />
            <Route path="/mint" element={<MintBadge />} />
            <Route path="/verify" element={<VerifyIdentity />} />
            <Route path="/verify-identity" element={<VerifyIdentity />} />
            <Route path="/direct-mint" element={<DirectMint />} />
            <Route path="/waitlist" element={<Waitlist />} />
            <Route path="/admin" element={<AdminMonitoring />} />
            <Route path="/admin/waitlist" element={<AdminWaitlist />} />
            <Route path="/poh" element={<ProofOfHumanity />} />
            <Route path="/poh/callback" element={<ProofOfHumanity />} />
          </Routes>
          <Footer />
        </BrowserRouter>
      </div>
    </WalletProvider>
  );
}

export default App;
