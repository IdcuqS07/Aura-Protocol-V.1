import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Shield, Award, Lock, CheckCircle, Calendar, TrendingUp, Activity, Loader, Wallet } from 'lucide-react';
import { useWallet } from './WalletContext';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || (window.location.hostname === 'localhost' ? 'http://localhost:9000' : 'https://www.aurapass.xyz');
const API = `${BACKEND_URL}/api`;
const CONTRACT_ADDRESS = '0xbAEe1fC5e41adB7aB303a23907cDEFAEf0aD763c';

const CreditPassport = () => {
  const { address, isConnected } = useWallet();
  const [passport, setPassport] = useState(null);
  const [scoreData, setScoreData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [minting, setMinting] = useState(false);

  useEffect(() => {
    if (isConnected && address) {
      loadPassportData();
    } else {
      setLoading(false);
    }
  }, [isConnected, address]);

  const loadPassportData = async () => {
    try {
      setLoading(true);
      
      // Try to get existing passport
      try {
        const passportRes = await axios.get(`${API}/passport/${address}`);
        if (passportRes.data.success) {
          setPassport(passportRes.data.passport);
        }
      } catch (err) {
        // Passport doesn't exist yet
        setPassport(null);
      }
      
      // Get score data
      const scoreRes = await axios.post(`${API}/passport/calculate-score`, {
        wallet_address: address
      });
      
      if (scoreRes.data.success) {
        setScoreData(scoreRes.data);
      }
    } catch (error) {
      console.error('Load passport error:', error);
    } finally {
      setLoading(false);
    }
  };
  
  const handleMintPassport = async () => {
    if (!scoreData) {
      alert('Please wait for score calculation...');
      return;
    }

    try {
      setMinting(true);
      
      const { credit_score, grade, breakdown } = scoreData;
      
      // Confirm with user
      const confirmed = window.confirm(
        `Mint Credit Passport?\n\n` +
        `Credit Score: ${credit_score}/1000\n` +
        `Grade: ${grade}\n` +
        `PoH: ${breakdown.poh_points} points\n` +
        `Badges: ${breakdown.badge_points} points\n` +
        `Activity: ${breakdown.activity_points} points\n\n` +
        `You will pay gas fee (~$0.01)`
      );
      
      if (!confirmed) return;
      
      // Get encrypted profile (empty for now)
      const encryptedProfile = '';
      
      // Mint via MetaMask
      if (!window.ethers) {
        alert('Ethers.js not loaded. Please refresh the page.');
        return;
      }

      const provider = new window.ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      
      const abi = [
        'function mintPassport(uint256 creditScore, string memory encryptedProfile) external returns (uint256)'
      ];
      
      const contract = new window.ethers.Contract(CONTRACT_ADDRESS, abi, signer);
      
      console.log('Minting passport with score:', credit_score);
      const tx = await contract.mintPassport(credit_score, encryptedProfile);
      
      alert(`Transaction sent! Waiting for confirmation...\nTX: ${tx.hash}`);
      
      const receipt = await tx.wait();
      console.log('Mint receipt:', receipt);
      
      // Extract token ID from event
      const event = receipt.events?.find(e => e.event === 'PassportMinted');
      const tokenId = event?.args?.tokenId?.toNumber() || 0;
      
      // Store in backend
      await axios.post(`${API}/passport/store`, {
        wallet_address: address,
        tx_hash: receipt.transactionHash,
        token_id: tokenId,
        encrypted_profile: encryptedProfile
      });
      
      alert(`✅ Passport minted successfully!\nToken ID: ${tokenId}\nTX: ${receipt.transactionHash}`);
      
      // Reload data
      await loadPassportData();
    } catch (error) {
      console.error('Mint error:', error);
      if (error.message?.includes('user rejected')) {
        alert('Transaction cancelled');
      } else if (error.message?.includes('already exists')) {
        alert('You already have a passport!');
      } else {
        alert(`Error: ${error.message || 'Failed to mint passport'}`);
      }
    } finally {
      setMinting(false);
    }
  };

  const getGradeColor = (grade) => {
    const colors = {
      'AAA': 'from-green-600 to-emerald-600',
      'AA': 'from-blue-600 to-cyan-600',
      'A': 'from-purple-600 to-blue-600',
      'BBB': 'from-yellow-600 to-orange-600',
      'BB': 'from-orange-600 to-red-600',
      'B': 'from-red-600 to-rose-600'
    };
    return colors[grade] || colors.BBB;
  };

  if (!isConnected) {
    return (
      <div className="min-h-screen pt-16 px-4 py-8">
        <div className="max-w-4xl mx-auto text-center py-20">
          <Shield className="w-24 h-24 text-gray-600 mx-auto mb-6" />
          <h1 className="text-4xl font-bold text-white mb-4">Connect Wallet</h1>
          <p className="text-gray-400">Please connect your wallet to view your Credit Passport.</p>
        </div>
      </div>
    );
  }
  
  if (loading) {
    return (
      <div className="min-h-screen pt-16 flex items-center justify-center">
        <Loader className="w-12 h-12 text-purple-500 animate-spin" />
      </div>
    );
  }

  if (!passport) {
    return (
      <div className="min-h-screen pt-16 px-4 py-8">
        <div className="max-w-4xl mx-auto">
          <div className="text-center py-12">
            <Shield className="w-24 h-24 text-gray-600 mx-auto mb-6" />
            <h1 className="text-4xl font-bold text-white mb-4">Create Your Credit Passport</h1>
            <p className="text-gray-400 mb-8">
              Mint your on-chain financial identity as a Soulbound NFT
            </p>
          </div>

          {scoreData && (
            <div className="mb-8 p-8 bg-gradient-to-br from-purple-900/30 to-blue-900/30 rounded-2xl border border-purple-500/30">
              <h2 className="text-2xl font-bold text-white mb-6">Your Credit Score Preview</h2>
              
              <div className="grid md:grid-cols-3 gap-6 mb-6">
                <div className="p-6 bg-white/5 rounded-xl">
                  <div className="text-gray-400 text-sm mb-2">Credit Score</div>
                  <div className="text-4xl font-bold text-white">{scoreData.credit_score}</div>
                  <div className="text-purple-400 text-sm mt-1">/ 1000</div>
                </div>
                <div className="p-6 bg-white/5 rounded-xl">
                  <div className="text-gray-400 text-sm mb-2">Grade</div>
                  <div className="text-4xl font-bold text-white">{scoreData.grade}</div>
                </div>
                <div className="p-6 bg-white/5 rounded-xl">
                  <div className="text-gray-400 text-sm mb-2">Status</div>
                  <div className="text-2xl font-bold text-green-400">Ready</div>
                </div>
              </div>

              <div className="space-y-3 mb-8">
                <div className="flex justify-between items-center p-4 bg-white/5 rounded-lg">
                  <span className="text-gray-300">PoH Score (40%)</span>
                  <span className="text-white font-bold">{scoreData.breakdown.poh_points} points</span>
                </div>
                <div className="flex justify-between items-center p-4 bg-white/5 rounded-lg">
                  <span className="text-gray-300">Badges (30%)</span>
                  <span className="text-white font-bold">{scoreData.breakdown.badge_points} points</span>
                </div>
                <div className="flex justify-between items-center p-4 bg-white/5 rounded-lg">
                  <span className="text-gray-300">On-chain Activity (30%)</span>
                  <span className="text-white font-bold">{scoreData.breakdown.activity_points} points</span>
                </div>
              </div>

              <button
                onClick={handleMintPassport}
                disabled={minting}
                className="w-full py-4 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-xl font-bold text-lg hover:shadow-lg hover:shadow-purple-500/50 transition-all disabled:opacity-50 flex items-center justify-center"
              >
                {minting ? (
                  <>
                    <Loader className="w-6 h-6 mr-2 animate-spin" />
                    Minting...
                  </>
                ) : (
                  <>
                    <Wallet className="w-6 h-6 mr-2" />
                    Mint Passport (Pay Gas)
                  </>
                )}
              </button>
              
              <p className="text-center text-gray-400 text-sm mt-4">
                Gas fee: ~$0.01 • Soulbound (non-transferable)
              </p>
            </div>
          )}

          <div className="text-center">
            <a
              href="/poh"
              className="inline-block px-8 py-4 bg-gradient-to-r from-green-600 to-emerald-600 text-white rounded-lg font-medium hover:shadow-lg hover:shadow-green-500/50 transition-all"
            >
              Complete PoH First
            </a>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen pt-16 px-4 py-8">
      <div className="max-w-6xl mx-auto">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-white mb-2">ZK Credit Passport</h1>
          <p className="text-gray-400">Your decentralized financial identity on Polygon</p>
        </div>

        {/* Passport Card */}
        <div className="mb-8">
          <div className={`p-8 bg-gradient-to-br ${getGradeColor(passport.grade)} rounded-3xl shadow-2xl relative overflow-hidden`}>
            <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -mr-32 -mt-32"></div>
            <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/10 rounded-full -ml-24 -mb-24"></div>
            
            <div className="relative z-10">
              <div className="flex items-start justify-between mb-8">
                <div>
                  <div className="text-white/80 text-sm mb-1">AURA PROTOCOL</div>
                  <div className="text-3xl font-bold text-white">Credit Passport</div>
                </div>
                <Shield className="w-16 h-16 text-white/30" />
              </div>

              <div className="grid grid-cols-2 gap-6 mb-8">
                <div>
                  <div className="text-white/70 text-sm mb-1">Wallet Address</div>
                  <div className="text-lg font-bold text-white font-mono">{address?.slice(0, 10)}...{address?.slice(-8)}</div>
                </div>
                <div>
                  <div className="text-white/70 text-sm mb-1">Token ID</div>
                  <div className="text-lg font-bold text-white">#{passport.token_id}</div>
                </div>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                  <div className="text-white/70 text-xs mb-1">Credit Score</div>
                  <div className="text-2xl font-bold text-white">{passport.credit_score}</div>
                </div>
                <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                  <div className="text-white/70 text-xs mb-1">Grade</div>
                  <div className="text-2xl font-bold text-white">{passport.grade}</div>
                </div>
                <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                  <div className="text-white/70 text-xs mb-1">Status</div>
                  <div className="text-lg font-bold text-white flex items-center">
                    <CheckCircle className="w-5 h-5 mr-1" />
                    Active
                  </div>
                </div>
              </div>

              <div className="mt-6 text-white/50 text-xs">
                Minted: {new Date(passport.created_at).toLocaleDateString()}
              </div>
            </div>
          </div>
        </div>

        {/* Details Grid */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* Score Breakdown */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <TrendingUp className="w-6 h-6 mr-2 text-purple-400" />
              Score Breakdown
            </h3>
            <div className="space-y-4">
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-gray-400">PoH Score (40%)</span>
                  <span className="text-white font-bold">{passport.breakdown.poh_points} pts</span>
                </div>
                <div className="w-full bg-gray-700 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-green-600 to-emerald-600 h-2 rounded-full"
                    style={{ width: `${(passport.breakdown.poh_points / 400) * 100}%` }}
                  ></div>
                </div>
              </div>

              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-gray-400">Badges (30%)</span>
                  <span className="text-white font-bold">{passport.breakdown.badge_points} pts</span>
                </div>
                <div className="w-full bg-gray-700 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-purple-600 to-blue-600 h-2 rounded-full"
                    style={{ width: `${(passport.breakdown.badge_points / 300) * 100}%` }}
                  ></div>
                </div>
              </div>

              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-gray-400">Activity (30%)</span>
                  <span className="text-white font-bold">{passport.breakdown.activity_points} pts</span>
                </div>
                <div className="w-full bg-gray-700 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-cyan-600 to-blue-600 h-2 rounded-full"
                    style={{ width: `${(passport.breakdown.activity_points / 300) * 100}%` }}
                  ></div>
                </div>
              </div>
            </div>
          </div>

          {/* Transaction Info */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <Lock className="w-6 h-6 mr-2 text-blue-400" />
              On-Chain Details
            </h3>
            <div className="space-y-4">
              <div>
                <div className="text-sm text-gray-400 mb-2">Transaction Hash</div>
                <a 
                  href={`https://amoy.polygonscan.com/tx/${passport.tx_hash}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-3 bg-slate-900/50 rounded-lg font-mono text-xs text-purple-400 break-all hover:text-purple-300 block"
                >
                  {passport.tx_hash}
                </a>
              </div>
              <div>
                <div className="text-sm text-gray-400 mb-2">Contract Address</div>
                <a 
                  href={`https://amoy.polygonscan.com/address/${CONTRACT_ADDRESS}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-3 bg-slate-900/50 rounded-lg font-mono text-xs text-blue-400 break-all hover:text-blue-300 block"
                >
                  {CONTRACT_ADDRESS}
                </a>
              </div>
              <div>
                <div className="text-sm text-gray-400 mb-2">Minted Date</div>
                <div className="flex items-center space-x-2 text-white">
                  <Calendar className="w-4 h-4 text-gray-500" />
                  <span>{new Date(passport.created_at).toLocaleString()}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* API Access */}
        <div className="mt-8 p-6 bg-gradient-to-r from-purple-900/30 to-blue-900/30 rounded-2xl border border-purple-500/30">
          <h3 className="text-2xl font-bold text-white mb-4">Proof-as-a-Service API</h3>
          <p className="text-gray-300 mb-6">
            Use Aura Protocol's API to verify this passport in your dApp.
          </p>
          <div className="p-4 bg-slate-900/50 rounded-lg font-mono text-sm">
            <div className="text-purple-400">GET</div>
            <div className="text-gray-300 mt-1">{BACKEND_URL}/api/passport/{address}</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreditPassport;
