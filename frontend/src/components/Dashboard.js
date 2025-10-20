import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Shield, Award, TrendingUp, Activity, CheckCircle, AlertCircle, Clock, ExternalLink } from 'lucide-react';
import { useWallet } from './WalletContext';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const Dashboard = () => {
  const { address, isConnected } = useWallet();
  const [user, setUser] = useState(null);
  const [badges, setBadges] = useState([]);
  const [passport, setPassport] = useState(null);
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showVerifyModal, setShowVerifyModal] = useState(false);

  // Use wallet address or demo user
  const userId = user?.id || 'demo-user-123';

  useEffect(() => {
    if (isConnected && address) {
      initializeDashboard(address);
    } else {
      // Load demo user
      initializeDashboard();
    }
  }, [isConnected, address]);

  const initializeDashboard = async (walletAddress) => {
    try {
      let userData;
      
      if (walletAddress) {
        // Try to find user by wallet address
        try {
          const allUsers = await axios.get(`${API}/users`);
          userData = allUsers.data.find(u => u.wallet_address.toLowerCase() === walletAddress.toLowerCase());
          
          if (!userData) {
            // Create new user with connected wallet
            const createResponse = await axios.post(`${API}/users`, {
              wallet_address: walletAddress,
              username: `user_${walletAddress.slice(2, 8)}`,
              email: `${walletAddress.slice(2, 8)}@aura.io`
            });
            userData = createResponse.data;
          }
        } catch (error) {
          console.error('Error finding/creating user:', error);
        }
      } else {
        // Use demo user
        try {
          const response = await axios.get(`${API}/users/${userId}`);
          userData = response.data;
        } catch (error) {
          const createResponse = await axios.post(`${API}/users`, {
            wallet_address: '0x1234567890abcdef1234567890abcdef12345678',
            username: 'demo_user',
            email: 'demo@auraprotocol.io'
          });
          userData = createResponse.data;
        }
      }

      setUser(userData);

      // Get badges
      try {
        const badgesResponse = await axios.get(`${API}/badges/${userData.id}`);
        setBadges(badgesResponse.data);
      } catch (error) {
        console.log('No badges yet');
      }

      // Get passport
      try {
        const passportResponse = await axios.get(`${API}/passports/${userData.id}`);
        setPassport(passportResponse.data);
      } catch (error) {
        console.log('No passport yet');
      }

      // Get transactions
      try {
        const txResponse = await axios.get(`${API}/transactions/${userData.id}`);
        setTransactions(txResponse.data);
      } catch (error) {
        console.log('No transactions yet');
      }

      setLoading(false);
    } catch (error) {
      console.error('Error initializing dashboard:', error);
      setLoading(false);
    }
  };

  const handleVerifyIdentity = async (method) => {
    try {
      await axios.post(`${API}/users/${user.id}/verify?method=${method}`);
      setShowVerifyModal(false);
      // Refresh data
      if (isConnected && address) {
        initializeDashboard(address);
      } else {
        initializeDashboard();
      }
    } catch (error) {
      console.error('Verification error:', error);
    }
  };

  const handleCreatePassport = async () => {
    try {
      await axios.post(`${API}/passports?user_id=${user.id}`);
      // Refresh data
      if (isConnected && address) {
        initializeDashboard(address);
      } else {
        initializeDashboard();
      }
    } catch (error) {
      console.error('Create passport error:', error);
    }
  };

  const getCreditScoreColor = (score) => {
    if (score >= 750) return 'text-green-400';
    if (score >= 600) return 'text-yellow-400';
    return 'text-red-400';
  };

  const getRiskBadge = (risk) => {
    const colors = {
      low: 'bg-green-500/20 text-green-400',
      medium: 'bg-yellow-500/20 text-yellow-400',
      high: 'bg-red-500/20 text-red-400'
    };
    return colors[risk] || colors.medium;
  };

  if (loading) {
    return (
      <div className="min-h-screen pt-16 flex items-center justify-center">
        <div className="text-white text-xl">Loading Dashboard...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen pt-16 px-4 py-8" data-testid="dashboard">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8 fade-in">
          <h1 className="text-4xl font-bold text-white mb-2">Dashboard</h1>
          <p className="text-gray-400">Manage your on-chain identity and credibility</p>
          {!isConnected && (
            <div className="mt-4 p-4 bg-yellow-500/10 border border-yellow-500/30 rounded-lg">
              <p className="text-yellow-400 text-sm">💡 Connect your wallet to use with your own address</p>
            </div>
          )}
        </div>

        {/* Main Grid */}
        <div className="grid lg:grid-cols-3 gap-6">
          {/* Left Column - Profile & Credit Score */}
          <div className="lg:col-span-2 space-y-6">
            {/* Profile Card */}
            <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="profile-card">
              <div className="flex items-start justify-between mb-6">
                <div className="flex items-center space-x-4">
                  <div className="w-16 h-16 bg-gradient-to-r from-purple-600 to-blue-600 rounded-full flex items-center justify-center">
                    <span className="text-2xl font-bold text-white">{user?.username?.[0]?.toUpperCase()}</span>
                  </div>
                  <div>
                    <h2 className="text-2xl font-bold text-white">{user?.username}</h2>
                    <p className="text-gray-400 text-sm font-mono">{user?.wallet_address?.slice(0, 16)}...</p>
                  </div>
                </div>
                {user?.is_verified ? (
                  <div className="flex items-center space-x-2 px-3 py-1 bg-green-500/20 rounded-full">
                    <CheckCircle className="w-4 h-4 text-green-400" />
                    <span className="text-green-400 text-sm font-medium">Verified</span>
                  </div>
                ) : (
                  <button
                    onClick={() => setShowVerifyModal(true)}
                    className="px-4 py-2 bg-purple-600 text-white rounded-lg text-sm font-medium hover:bg-purple-700 transition"
                    data-testid="verify-identity-btn"
                  >
                    Verify Identity
                  </button>
                )}
              </div>

              {/* Credit Score */}
              <div className="grid md:grid-cols-3 gap-4">
                <div className="p-4 bg-slate-900/50 rounded-xl">
                  <div className="flex items-center space-x-2 mb-2">
                    <TrendingUp className="w-5 h-5 text-purple-400" />
                    <span className="text-gray-400 text-sm">Credit Score</span>
                  </div>
                  <div className={`text-3xl font-bold ${getCreditScoreColor(user?.credit_score || 0)}`}>
                    {user?.credit_score || 0}
                  </div>
                  <div className="text-xs text-gray-500 mt-1">out of 1000</div>
                </div>
                <div className="p-4 bg-slate-900/50 rounded-xl">
                  <div className="flex items-center space-x-2 mb-2">
                    <Activity className="w-5 h-5 text-blue-400" />
                    <span className="text-gray-400 text-sm">Reputation</span>
                  </div>
                  <div className="text-3xl font-bold text-blue-400">
                    {user?.reputation_score?.toFixed(1) || '0.0'}
                  </div>
                  <div className="text-xs text-gray-500 mt-1">out of 100</div>
                </div>
                <div className="p-4 bg-slate-900/50 rounded-xl">
                  <div className="flex items-center space-x-2 mb-2">
                    <Award className="w-5 h-5 text-cyan-400" />
                    <span className="text-gray-400 text-sm">Badges</span>
                  </div>
                  <div className="text-3xl font-bold text-cyan-400">
                    {badges.length}
                  </div>
                  <div className="text-xs text-gray-500 mt-1">earned</div>
                </div>
              </div>
            </div>

            {/* Credit Passport */}
            <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="passport-section">
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-2xl font-bold text-white">ZK Credit Passport</h3>
                {!passport && user?.is_verified && (
                  <button
                    onClick={handleCreatePassport}
                    className="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg text-sm font-medium hover:shadow-lg hover:shadow-purple-500/50 transition"
                    data-testid="create-passport-btn"
                  >
                    Create Passport
                  </button>
                )}
              </div>

              {passport ? (
                <div className="space-y-4">
                  <div className="p-6 bg-gradient-to-r from-purple-900/30 to-blue-900/30 rounded-xl border border-purple-500/30">
                    <div className="flex items-center justify-between mb-4">
                      <div>
                        <div className="text-sm text-gray-400 mb-1">Passport ID</div>
                        <div className="text-lg font-bold text-white font-mono">{passport.passport_id}</div>
                      </div>
                      <div className={`px-3 py-1 rounded-full text-xs font-medium ${getRiskBadge(passport.risk_level)}`}>
                        {passport.risk_level?.toUpperCase()} RISK
                      </div>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <div className="text-sm text-gray-400">Soulbound Token</div>
                        <div className="text-sm font-mono text-purple-400">{passport.soulbound_token_id}</div>
                      </div>
                      <div>
                        <div className="text-sm text-gray-400">Transactions</div>
                        <div className="text-sm text-white">{passport.total_transactions}</div>
                      </div>
                    </div>
                  </div>
                  <div className="text-xs text-gray-500">
                    ZK Proof: {passport.zk_proof_hash?.slice(0, 32)}...
                  </div>
                </div>
              ) : (
                <div className="text-center py-8">
                  <Shield className="w-16 h-16 text-gray-600 mx-auto mb-4" />
                  <p className="text-gray-400">
                    {user?.is_verified 
                      ? 'Create your Credit Passport to unlock full features'
                      : 'Verify your identity first to create a Credit Passport'
                    }
                  </p>
                </div>
              )}
            </div>
          </div>

          {/* Right Column - Badges & Activity */}
          <div className="space-y-6">
            {/* ZK Badges */}
            <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="badges-section">
              <h3 className="text-xl font-bold text-white mb-4">ZK-ID Badges</h3>
              {badges.length > 0 ? (
                <div className="space-y-3">
                  {badges.map((badge) => (
                    <div
                      key={badge.id}
                      className="p-4 bg-slate-900/50 rounded-xl border border-purple-500/20"
                    >
                      <div className="flex items-center space-x-3">
                        <div className="w-10 h-10 bg-gradient-to-r from-purple-600 to-blue-600 rounded-lg flex items-center justify-center">
                          <Award className="w-6 h-6 text-white" />
                        </div>
                        <div className="flex-1">
                          <div className="text-sm font-medium text-white capitalize">{badge.badge_type}</div>
                          <div className="text-xs text-gray-400 font-mono">{badge.token_id}</div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8">
                  <Award className="w-12 h-12 text-gray-600 mx-auto mb-3" />
                  <p className="text-gray-400 text-sm">No badges yet. Verify your identity to earn badges.</p>
                </div>
              )}
            </div>

            {/* Recent Activity */}
            <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="activity-section">
              <h3 className="text-xl font-bold text-white mb-4">Recent Activity</h3>
              {transactions.length > 0 ? (
                <div className="space-y-3">
                  {transactions.slice(0, 5).map((tx) => (
                    <div key={tx.id} className="flex items-center space-x-3 text-sm">
                      <Clock className="w-4 h-4 text-gray-500" />
                      <div className="flex-1">
                        <div className="text-white capitalize">{tx.tx_type}</div>
                        <div className="text-gray-400 text-xs">{tx.protocol}</div>
                      </div>
                      <div className="text-purple-400 font-medium">${tx.amount}</div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8">
                  <Activity className="w-12 h-12 text-gray-600 mx-auto mb-3" />
                  <p className="text-gray-400 text-sm">No activity yet</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Verify Identity Modal */}
      {showVerifyModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50" data-testid="verify-modal">
          <div className="bg-slate-900 p-8 rounded-2xl border border-purple-500/30 max-w-md w-full mx-4">
            <h3 className="text-2xl font-bold text-white mb-4">Verify Identity</h3>
            <p className="text-gray-400 mb-6">Choose a verification method:</p>
            <div className="space-y-3">
              {['civic', 'worldcoin', 'lens'].map((method) => (
                <button
                  key={method}
                  onClick={() => handleVerifyIdentity(method)}
                  className="w-full p-4 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-left transition"
                  data-testid={`verify-${method}-btn`}
                >
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-6 h-6 text-purple-400" />
                    <div>
                      <div className="text-white font-medium capitalize">{method}</div>
                      <div className="text-gray-400 text-sm">Verify with {method}</div>
                    </div>
                  </div>
                </button>
              ))}
            </div>
            <button
              onClick={() => setShowVerifyModal(false)}
              className="w-full mt-4 px-4 py-2 bg-gray-700 text-white rounded-lg hover:bg-gray-600 transition"
              data-testid="close-verify-modal-btn"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Dashboard;
