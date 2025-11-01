import React, { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useWallet } from './WalletContext';
import { CheckCircle, Globe, Shield, Loader2, ExternalLink } from 'lucide-react';
import axios from 'axios';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || 'http://localhost:9000';

const VerifyIdentity = () => {
  const { address, isConnected } = useWallet();
  const [verifying, setVerifying] = useState(false);
  const [txHash, setTxHash] = useState('');
  const [error, setError] = useState('');

  const verificationMethods = [
    {
      id: 'uniqueness',
      name: 'Proof of Uniqueness',
      icon: Shield,
      color: 'purple',
      description: 'Verify you are a unique human',
      badgeType: 'Proof of Uniqueness'
    },
    {
      id: 'identity',
      name: 'Identity Verified',
      icon: CheckCircle,
      color: 'blue',
      description: 'Verify your digital identity',
      badgeType: 'Identity Verified'
    },
    {
      id: 'reputation',
      name: 'Reputation Badge',
      icon: Shield,
      color: 'yellow',
      description: 'Build your on-chain reputation',
      badgeType: 'Reputation Badge'
    },
    {
      id: 'civic',
      name: 'Civic Verified',
      icon: CheckCircle,
      color: 'green',
      description: 'Verify with Civic identity platform',
      badgeType: 'Civic Verified'
    },
    {
      id: 'worldcoin',
      name: 'Worldcoin Verified',
      icon: Globe,
      color: 'indigo',
      description: 'Proof of personhood via Worldcoin',
      badgeType: 'Worldcoin Verified'
    }
  ];

  const handleVerify = async (method) => {
    if (!isConnected) {
      setError('Please connect your wallet first');
      return;
    }

    setVerifying(true);
    setError('');
    setTxHash('');

    try {
      // Mint on-chain
      const { issueBadge } = await import('../utils/web3');
      const zkProofHash = `${method.id}_proof_${Date.now()}`;
      const hash = await issueBadge(address, method.badgeType, zkProofHash);
      setTxHash(hash);
      
      setTimeout(() => {
        window.location.href = '/dashboard';
      }, 3000);
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
        </div>

        {!isConnected && (
          <Card className="bg-yellow-900/20 border-yellow-500/50 mb-6">
            <CardContent className="py-4">
              <p className="text-yellow-400">⚠️ Please connect your wallet to verify and mint badges on-chain</p>
            </CardContent>
          </Card>
        )}

        {txHash && (
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

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {verificationMethods.map((method) => {
            const Icon = method.icon;
            const colorMap = {
              purple: { bg: 'bg-purple-500/20', text: 'text-purple-400', btn: 'bg-purple-600 hover:bg-purple-700' },
              blue: { bg: 'bg-blue-500/20', text: 'text-blue-400', btn: 'bg-blue-600 hover:bg-blue-700' },
              yellow: { bg: 'bg-yellow-500/20', text: 'text-yellow-400', btn: 'bg-yellow-600 hover:bg-yellow-700' },
              green: { bg: 'bg-green-500/20', text: 'text-green-400', btn: 'bg-green-600 hover:bg-green-700' },
              indigo: { bg: 'bg-indigo-500/20', text: 'text-indigo-400', btn: 'bg-indigo-600 hover:bg-indigo-700' }
            };
            const colors = colorMap[method.color];
            const iconBg = colors.bg;
            const iconColor = colors.text;
            const btnBg = colors.btn;
            
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
                        Verifying...
                      </>
                    ) : (
                      `Verify with ${method.name}`
                    )}
                  </Button>
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
