import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Shield, Award, Lock, CheckCircle, Calendar, Hash, TrendingUp, Activity } from 'lucide-react';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

const CreditPassport = () => {
  const [passport, setPassport] = useState(null);
  const [user, setUser] = useState(null);
  const [badges, setBadges] = useState([]);
  const [loading, setLoading] = useState(true);

  const demoUserId = 'demo-user-123';

  useEffect(() => {
    loadPassportData();
  }, []);

  const loadPassportData = async () => {
    try {
      // Get user
      const userResponse = await axios.get(`${API}/users/${demoUserId}`);
      setUser(userResponse.data);

      // Get passport
      try {
        const passportResponse = await axios.get(`${API}/passports/${demoUserId}`);
        setPassport(passportResponse.data);
      } catch (error) {
        console.log('No passport found');
      }

      // Get badges
      try {
        const badgesResponse = await axios.get(`${API}/badges/${demoUserId}`);
        setBadges(badgesResponse.data);
      } catch (error) {
        console.log('No badges found');
      }

      setLoading(false);
    } catch (error) {
      console.error('Error loading passport:', error);
      setLoading(false);
    }
  };

  const getRiskColor = (risk) => {
    const colors = {
      low: 'from-green-600 to-emerald-600',
      medium: 'from-yellow-600 to-orange-600',
      high: 'from-red-600 to-rose-600'
    };
    return colors[risk] || colors.medium;
  };

  const getCreditScoreGrade = (score) => {
    if (score >= 850) return 'Excellent';
    if (score >= 750) return 'Very Good';
    if (score >= 650) return 'Good';
    if (score >= 550) return 'Fair';
    return 'Poor';
  };

  if (loading) {
    return (
      <div className="min-h-screen pt-16 flex items-center justify-center">
        <div className="text-white text-xl">Loading Passport...</div>
      </div>
    );
  }

  if (!passport) {
    return (
      <div className="min-h-screen pt-16 px-4 py-8" data-testid="no-passport">
        <div className="max-w-4xl mx-auto text-center py-20">
          <Shield className="w-24 h-24 text-gray-600 mx-auto mb-6" />
          <h1 className="text-4xl font-bold text-white mb-4">No Credit Passport Found</h1>
          <p className="text-gray-400 mb-8">
            You need to verify your identity and create a passport first.
          </p>
          <a
            href="/dashboard"
            className="inline-block px-8 py-4 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg font-medium hover:shadow-lg hover:shadow-purple-500/50 transition-all"
          >
            Go to Dashboard
          </a>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen pt-16 px-4 py-8" data-testid="credit-passport-page">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="mb-8 fade-in">
          <h1 className="text-4xl font-bold text-white mb-2">ZK Credit Passport</h1>
          <p className="text-gray-400">Your decentralized financial identity on Polygon</p>
        </div>

        {/* Main Passport Card */}
        <div className="mb-8">
          <div className="relative overflow-hidden">
            {/* Passport Visual */}
            <div className={`p-8 bg-gradient-to-br ${getRiskColor(passport.risk_level)} rounded-3xl shadow-2xl`}>
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
                    <div className="text-white/70 text-sm mb-1">Passport ID</div>
                    <div className="text-xl font-bold text-white font-mono">{passport.passport_id}</div>
                  </div>
                  <div>
                    <div className="text-white/70 text-sm mb-1">Risk Level</div>
                    <div className="text-xl font-bold text-white uppercase">{passport.risk_level}</div>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-4">
                  <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                    <div className="text-white/70 text-xs mb-1">Credit Score</div>
                    <div className="text-2xl font-bold text-white">{passport.credit_score}</div>
                  </div>
                  <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                    <div className="text-white/70 text-xs mb-1">Reputation</div>
                    <div className="text-2xl font-bold text-white">{passport.reputation_score.toFixed(1)}</div>
                  </div>
                  <div className="p-4 bg-white/10 backdrop-blur-sm rounded-xl">
                    <div className="text-white/70 text-xs mb-1">Transactions</div>
                    <div className="text-2xl font-bold text-white">{passport.total_transactions}</div>
                  </div>
                </div>

                <div className="mt-6 text-white/50 text-xs">
                  Soulbound Token: {passport.soulbound_token_id}
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Details Grid */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* Credit Analysis */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="credit-analysis">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <TrendingUp className="w-6 h-6 mr-2 text-purple-400" />
              Credit Analysis
            </h3>
            <div className="space-y-4">
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-gray-400">Credit Grade</span>
                  <span className="text-white font-bold">{getCreditScoreGrade(passport.credit_score)}</span>
                </div>
                <div className="w-full bg-gray-700 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-purple-600 to-blue-600 h-2 rounded-full transition-all"
                    style={{ width: `${(passport.credit_score / 1000) * 100}%` }}
                  ></div>
                </div>
              </div>

              <div className="pt-4 border-t border-white/10">
                <div className="text-sm text-gray-400 mb-3">Score Breakdown</div>
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-400">Payment History</span>
                    <span className="text-white">95%</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-400">On-Chain Activity</span>
                    <span className="text-white">88%</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-400">Protocol Reputation</span>
                    <span className="text-white">92%</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* ZK Proof Details */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="zk-proof-details">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <Lock className="w-6 h-6 mr-2 text-blue-400" />
              ZK Proof Details
            </h3>
            <div className="space-y-4">
              <div>
                <div className="text-sm text-gray-400 mb-2">Proof Hash</div>
                <div className="p-3 bg-slate-900/50 rounded-lg font-mono text-xs text-purple-400 break-all">
                  {passport.zk_proof_hash}
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-400 mb-2">Verification Status</div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                  <span className="text-green-400 font-medium">Verified</span>
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-400 mb-2">Issued Date</div>
                <div className="flex items-center space-x-2 text-white">
                  <Calendar className="w-4 h-4 text-gray-500" />
                  <span>{new Date(passport.issued_at).toLocaleDateString()}</span>
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-400 mb-2">Last Updated</div>
                <div className="flex items-center space-x-2 text-white">
                  <Activity className="w-4 h-4 text-gray-500" />
                  <span>{new Date(passport.last_updated).toLocaleDateString()}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Badges */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="badges-collection">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <Award className="w-6 h-6 mr-2 text-cyan-400" />
              Badges Collection
            </h3>
            {badges.length > 0 ? (
              <div className="grid grid-cols-2 gap-3">
                {badges.map((badge) => (
                  <div
                    key={badge.id}
                    className="p-4 bg-gradient-to-br from-purple-900/30 to-blue-900/30 rounded-xl border border-purple-500/20"
                  >
                    <Award className="w-8 h-8 text-purple-400 mb-2" />
                    <div className="text-sm font-medium text-white capitalize">{badge.badge_type}</div>
                    <div className="text-xs text-gray-400 mt-1 font-mono">{badge.token_id}</div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-400">
                No badges earned yet
              </div>
            )}
          </div>

          {/* Transaction Volume */}
          <div className="p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10" data-testid="transaction-stats">
            <h3 className="text-xl font-bold text-white mb-6 flex items-center">
              <Hash className="w-6 h-6 mr-2 text-green-400" />
              Transaction Stats
            </h3>
            <div className="space-y-4">
              <div className="p-4 bg-slate-900/50 rounded-xl">
                <div className="text-sm text-gray-400 mb-1">Total Volume</div>
                <div className="text-3xl font-bold text-green-400">
                  ${passport.total_volume.toLocaleString()}
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-slate-900/50 rounded-lg">
                  <div className="text-xs text-gray-400 mb-1">Transactions</div>
                  <div className="text-xl font-bold text-white">{passport.total_transactions}</div>
                </div>
                <div className="p-3 bg-slate-900/50 rounded-lg">
                  <div className="text-xs text-gray-400 mb-1">Avg. Size</div>
                  <div className="text-xl font-bold text-white">
                    ${passport.total_transactions > 0 
                      ? (passport.total_volume / passport.total_transactions).toFixed(0)
                      : 0
                    }
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* API Access Section */}
        <div className="mt-8 p-6 bg-gradient-to-r from-purple-900/30 to-blue-900/30 backdrop-blur-sm rounded-2xl border border-purple-500/30" data-testid="api-access">
          <h3 className="text-2xl font-bold text-white mb-4">Proof-as-a-Service API</h3>
          <p className="text-gray-300 mb-6">
            Use Aura Protocol's API to verify this passport in your dApp or smart contract.
          </p>
          <div className="p-4 bg-slate-900/50 rounded-lg font-mono text-sm">
            <div className="text-purple-400">GET</div>
            <div className="text-gray-300 mt-1">{BACKEND_URL}/api/proof/verify/{user?.id}</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreditPassport;
