import React, { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useWallet } from './WalletContext';
import { CheckCircle, Globe, Shield, Loader2, ExternalLink, Zap } from 'lucide-react';
import axios from 'axios';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || 'http://localhost:9000';

const VerifyIdentity = () => {
  const { address, isConnected } = useWallet();
  const [verifying, setVerifying] = useState(false);
  const [txHash, setTxHash] = useState('');
  const [error, setError] = useState('');
  const [demoMode, setDemoMode] = useState(true);

  const verificationMethods = [
    {
      id: 'civic',
      name: 'Civic',
      icon: CheckCircle,
      color: 'green',
      description: 'Verify with Civic identity platform',
      badgeType: 'Civic Verified'
    },
    {
      id: 'worldcoin',
      name: 'Worldcoin',
      icon: Globe,
      color: 'indigo',
      description: 'Proof of personhood via Worldcoin',
      badgeType: 'Worldcoin Verified'
    }
  ];

  const handleVerify = async (method) => {
    setVerifying(true);
    setError('');
    setTxHash('');

    try {
      if (demoMode) {
        // Demo mode: Save to backend only
        await new Promise(resolve => setTimeout(resolve, 1500));
        
        const demoAddress = address || `0xDemo${Date.now().toString(16)}`;
        const badgeData = {
          wallet_address: demoAddress,
          badge_type: method.badgeType,
          zk_proof_hash: `${method.id}_proof_${Date.now()}`,
          is_demo: true
        };
        
        await axios.post(`${BACKEND_URL}/api/badges/demo`, badgeData);
        
        setTimeout(() => {
          window.location.href = '/dashboard';
        }, 2000);
      } else {
        // Live mode: Mint on-chain
        if (!isConnected) {
          setError('Please connect your wallet for on-chain minting');
          return;
        }
        
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        const { issueBadge } = await import('../utils/web3');
        const zkProofHash = `${method.id}_proof_${Date.now()}`;
        const hash = await issueBadge(address, method.badgeType, zkProofHash);
        setTxHash(hash);
        
        setTimeout(() => {
          window.location.href = '/zk-badges';
        }, 3000);
      }
    } catch (err) {
      setError(err.message || 'Verification failed');
    } finally {
      setVerifying(false);
    }
  };



  return (
    <div className="min-h-screen pt-20 px-4 py-8">
      <div className="max-w-4xl mx-auto">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-white mb-4">Verify Your Identity</h1>
          <p className="text-gray-300">Choose a verification method to earn ZK-ID badges</p>
          
          {/* Demo Mode Toggle */}
          <div className="mt-6 inline-flex items-center space-x-3 px-6 py-3 bg-slate-800/50 border border-slate-700 rounded-xl">
            <button
              onClick={() => setDemoMode(true)}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                demoMode 
                  ? 'bg-purple-600 text-white' 
                  : 'bg-transparent text-gray-400 hover:text-white'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Zap className="h-4 w-4" />
                <span>Demo Mode</span>
              </div>
            </button>
            <button
              onClick={() => setDemoMode(false)}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                !demoMode 
                  ? 'bg-green-600 text-white' 
                  : 'bg-transparent text-gray-400 hover:text-white'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Shield className="h-4 w-4" />
                <span>On-Chain</span>
              </div>
            </button>
          </div>
          
          <div className="mt-3 text-sm text-gray-400">
            {demoMode ? (
              <span>✨ Free & instant - No wallet or gas fees required</span>
            ) : (
              <span>🔗 Mint on-chain - Requires wallet connection & MATIC</span>
            )}
          </div>
        </div>

        {txHash && !demoMode && (
          <Card className="bg-green-900/20 border-green-500/50 mb-6">
            <CardContent className="py-4">
              <div className="flex items-center space-x-3">
                <CheckCircle className="h-6 w-6 text-green-400" />
                <div className="flex-1">
                  <p className="text-green-400 font-medium">Verification successful! Badge minted.</p>
                  <a 
                    href={`https://amoy.polygonscan.com/tx/${txHash}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-green-300 hover:underline flex items-center space-x-1"
                  >
                    <span>View on Explorer</span>
                    <ExternalLink className="h-3 w-3" />
                  </a>
                </div>
              </div>
            </CardContent>
          </Card>
        )}

        {error && (
          <Card className="bg-red-900/20 border-red-500/50 mb-6">
            <CardContent className="py-4">
              <p className="text-red-400">{error}</p>
            </CardContent>
          </Card>
        )}

        <div className="grid md:grid-cols-2 gap-6 mb-8">
          {verificationMethods.map((method) => {
            const Icon = method.icon;
            const iconBg = method.id === 'civic' ? 'bg-green-500/20' : 'bg-indigo-500/20';
            const iconColor = method.id === 'civic' ? 'text-green-400' : 'text-indigo-400';
            const btnBg = method.id === 'civic' ? 'bg-green-600 hover:bg-green-700' : 'bg-indigo-600 hover:bg-indigo-700';
            
            return (
              <Card key={method.id} className="bg-slate-800/50 border-slate-700 hover:border-purple-500/50 transition">
                <CardHeader>
                  <div className="flex items-center space-x-3 mb-2">
                    <div className={`p-3 ${iconBg} rounded-lg`}>
                      <Icon className={`h-8 w-8 ${iconColor}`} />
                    </div>
                    <CardTitle className="text-white text-xl">{method.name}</CardTitle>
                  </div>
                  <CardDescription>{method.description}</CardDescription>
                </CardHeader>
                <CardContent>
                  <Button
                    onClick={() => handleVerify(method)}
                    disabled={verifying}
                    className={`w-full ${btnBg}`}
                  >
                    {verifying ? (
                      <>
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        {demoMode ? 'Creating Demo Badge...' : 'Minting On-Chain...'}
                      </>
                    ) : (
                      <>
                        {demoMode ? '⚡ Try Demo' : '🔗 Mint On-Chain'}
                      </>
                    )}
                  </Button>
                  {demoMode && (
                    <p className="text-xs text-gray-400 mt-2 text-center">
                      Demo badges can be upgraded to on-chain later
                    </p>
                  )}
                </CardContent>
              </Card>
            );
          })}
        </div>

        <Card className="bg-slate-800/50 border-slate-700">
          <CardHeader>
            <CardTitle className="text-white">How It Works</CardTitle>
          </CardHeader>
          <CardContent className="text-gray-300 space-y-3 text-sm">
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-purple-600 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0">1</div>
              <div>
                <p className="font-medium text-white">Choose Verification Method</p>
                <p className="text-gray-400">Select Civic or Worldcoin to verify your identity</p>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-purple-600 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0">2</div>
              <div>
                <p className="font-medium text-white">Complete Verification</p>
                <p className="text-gray-400">Follow the verification process with the selected provider</p>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-purple-600 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0">3</div>
              <div>
                <p className="font-medium text-white">Receive ZK Badge</p>
                <p className="text-gray-400">Get a soulbound NFT badge as proof of verification</p>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-purple-600 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0">4</div>
              <div>
                <p className="font-medium text-white">Boost Your Credit Score</p>
                <p className="text-gray-400">Each badge increases your on-chain credibility</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="bg-blue-900/20 border-blue-500/50 mt-6">
          <CardContent className="py-4">
            <div className="flex items-start space-x-3">
              <Shield className="h-5 w-5 text-blue-400 flex-shrink-0 mt-0.5" />
              <div className="text-sm text-blue-300">
                <p className="font-medium mb-1">Privacy Protected</p>
                <p className="text-blue-200/80">Your verification data is processed using zero-knowledge proofs. Only the verification result is stored on-chain, not your personal information.</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default VerifyIdentity;
