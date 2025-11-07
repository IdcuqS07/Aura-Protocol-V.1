import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Shield, Zap, Lock, TrendingUp, ArrowRight, CheckCircle, Globe } from 'lucide-react';

const LandingPage = () => {
  const [stats, setStats] = useState({ users: 0, verified: 0, passports: 0, volume: 0 });

  useEffect(() => {
    // Animate stats
    const targets = { users: 2847, verified: 2134, passports: 1892, volume: 45.7 };
    const duration = 2000;
    const steps = 60;
    const stepTime = duration / steps;

    let currentStep = 0;
    const interval = setInterval(() => {
      currentStep++;
      const progress = currentStep / steps;
      
      setStats({
        users: Math.floor(targets.users * progress),
        verified: Math.floor(targets.verified * progress),
        passports: Math.floor(targets.passports * progress),
        volume: (targets.volume * progress).toFixed(1)
      });

      if (currentStep >= steps) clearInterval(interval);
    }, stepTime);

    return () => clearInterval(interval);
  }, []);

  const features = [
    {
      icon: <Shield className="w-8 h-8" />,
      title: 'ZK-ID Badge',
      description: 'Unique identity proof with Zero-Knowledge Proofs for maximum privacy',
      color: 'from-purple-600 to-blue-600'
    },
    {
      icon: <Lock className="w-8 h-8" />,
      title: 'Credit Passport',
      description: 'Soulbound NFT representing your on-chain financial reputation',
      color: 'from-blue-600 to-cyan-600'
    },
    {
      icon: <Zap className="w-8 h-8" />,
      title: 'Proof-as-a-Service',
      description: 'Real-time credibility verification API without revealing personal data',
      color: 'from-cyan-600 to-teal-600'
    },
    {
      icon: <TrendingUp className="w-8 h-8" />,
      title: 'AI Risk Oracle',
      description: 'AI-powered risk assessment for more accurate and efficient lending',
      color: 'from-teal-600 to-green-600'
    }
  ];



  return (
    <div className="min-h-screen pt-16">
      {/* Hero Section */}
      <section className="relative py-20 px-4 overflow-hidden" data-testid="hero-section">
        <div className="absolute inset-0 bg-mesh opacity-30"></div>
        <div className="max-w-6xl mx-auto relative z-10">
          <div className="text-center fade-in">
            <div className="inline-block mb-4 px-4 py-2 bg-purple-500/10 border border-purple-500/30 rounded-full">
              <span className="text-purple-400 text-sm font-medium">🚀 Polygon ZK-ID Credit Layer</span>
            </div>
            <h1 className="text-5xl md:text-7xl font-bold text-white mb-6">
              Universal Trust in a
              <span className="gradient-text"> Trustless World</span>
            </h1>
            <p className="text-xl text-gray-300 mb-8 max-w-3xl mx-auto">
              Aura Protocol is a decentralized credibility layer that builds ZK Credit Passports — 
              on-chain financial identities that verify reputation without revealing personal data.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/verify"
                className="inline-flex items-center px-8 py-4 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg font-medium hover:shadow-lg hover:shadow-purple-500/50 transition-all"
                data-testid="get-started-btn"
              >
                Get Started <ArrowRight className="ml-2 w-5 h-5" />
              </Link>
              <a
                href="#features"
                className="inline-flex items-center px-8 py-4 bg-white/10 backdrop-blur-sm text-white rounded-lg font-medium border border-white/20 hover:bg-white/20 transition-all"
                data-testid="learn-more-btn"
              >
                Learn More
              </a>
            </div>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-16" data-testid="stats-section">
            <div className="text-center p-6 bg-white/5 backdrop-blur-sm rounded-xl border border-white/10">
              <div className="text-3xl font-bold text-purple-400">{stats.users.toLocaleString()}</div>
              <div className="text-sm text-gray-400 mt-2">Total Users</div>
            </div>
            <div className="text-center p-6 bg-white/5 backdrop-blur-sm rounded-xl border border-white/10">
              <div className="text-3xl font-bold text-blue-400">{stats.verified.toLocaleString()}</div>
              <div className="text-sm text-gray-400 mt-2">Verified Users</div>
            </div>
            <div className="text-center p-6 bg-white/5 backdrop-blur-sm rounded-xl border border-white/10">
              <div className="text-3xl font-bold text-cyan-400">{stats.passports.toLocaleString()}</div>
              <div className="text-sm text-gray-400 mt-2">Credit Passports</div>
            </div>
            <div className="text-center p-6 bg-white/5 backdrop-blur-sm rounded-xl border border-white/10">
              <div className="text-3xl font-bold text-green-400">${stats.volume}M</div>
              <div className="text-sm text-gray-400 mt-2">Total Volume</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 px-4" data-testid="features-section">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-white mb-4">Key Features</h2>
            <p className="text-gray-400 text-lg">Leading technology for decentralized credibility systems</p>
          </div>
          <div className="grid md:grid-cols-2 gap-8">
            {features.map((feature, index) => (
              <div
                key={index}
                className="p-8 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10 card-hover"
                data-testid={`feature-card-${index}`}
              >
                <div className={`inline-flex p-3 rounded-lg bg-gradient-to-r ${feature.color} mb-4`}>
                  {feature.icon}
                </div>
                <h3 className="text-2xl font-bold text-white mb-3">{feature.title}</h3>
                <p className="text-gray-400">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>



      {/* CTA Section */}
      <section className="py-20 px-4" data-testid="cta-section">
        <div className="max-w-4xl mx-auto text-center">
          <div className="p-12 bg-gradient-to-r from-purple-900/50 to-blue-900/50 backdrop-blur-sm rounded-3xl border border-purple-500/30">
            <Globe className="w-16 h-16 text-purple-400 mx-auto mb-6" />
            <h2 className="text-4xl font-bold text-white mb-4">
              Ready to Build Your On-Chain Reputation?
            </h2>
            <p className="text-gray-300 text-lg mb-8">
              Join the decentralized credibility ecosystem on Polygon
            </p>
            <Link
              to="/verify"
              className="inline-flex items-center px-8 py-4 bg-white text-purple-900 rounded-lg font-bold hover:shadow-lg hover:shadow-white/30 transition-all"
              data-testid="cta-dashboard-btn"
            >
              Start Verification <ArrowRight className="ml-2 w-5 h-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-4 border-t border-white/10 bg-gradient-to-b from-transparent to-black/30">
        <div className="max-w-6xl mx-auto">
          <div className="grid md:grid-cols-4 gap-8 mb-8">
            {/* Brand */}
            <div className="md:col-span-2">
              <div className="flex items-center space-x-2 mb-4">
                <Shield className="w-8 h-8 text-purple-400" />
                <span className="text-2xl font-bold text-white">Aura Protocol</span>
              </div>
              <p className="text-gray-400 mb-4 max-w-md">
                Universal Trust in a Trustless World. Building the future of decentralized credibility on Polygon.
              </p>
              <div className="flex space-x-4">
                <a href="https://github.com/IdcuqS07/Aura-Protocol-V.1" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">
                  <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>
                </a>
                <a href="https://twitter.com/auraprotocol" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">
                  <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg>
                </a>
                <a href="https://discord.gg/auraprotocol" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">
                  <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path d="M20.317 4.37a19.791 19.791 0 00-4.885-1.515.074.074 0 00-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 00-5.487 0 12.64 12.64 0 00-.617-1.25.077.077 0 00-.079-.037A19.736 19.736 0 003.677 4.37a.07.07 0 00-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 00.031.057 19.9 19.9 0 005.993 3.03.078.078 0 00.084-.028c.462-.63.874-1.295 1.226-1.994a.076.076 0 00-.041-.106 13.107 13.107 0 01-1.872-.892.077.077 0 01-.008-.128 10.2 10.2 0 00.372-.292.074.074 0 01.077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 01.078.01c.12.098.246.198.373.292a.077.077 0 01-.006.127 12.299 12.299 0 01-1.873.892.077.077 0 00-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 00.084.028 19.839 19.839 0 006.002-3.03.077.077 0 00.032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 00-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/></svg>
                </a>
              </div>
            </div>

            {/* Product */}
            <div>
              <h4 className="text-white font-bold mb-4">Product</h4>
              <ul className="space-y-2">
                <li><a href="/verify" className="text-gray-400 hover:text-purple-400 transition">Proof of Humanity</a></li>
                <li><a href="/passport" className="text-gray-400 hover:text-purple-400 transition">Credit Passport</a></li>
                <li><a href="/badges" className="text-gray-400 hover:text-purple-400 transition">ZK Badges</a></li>
                <li><a href="/oracle" className="text-gray-400 hover:text-purple-400 transition">AI Risk Oracle</a></li>
                <li><a href="/api" className="text-gray-400 hover:text-purple-400 transition">API</a></li>
              </ul>
            </div>

            {/* Resources */}
            <div>
              <h4 className="text-white font-bold mb-4">Resources</h4>
              <ul className="space-y-2">
                <li><a href="https://github.com/IdcuqS07/Aura-Protocol-V.1" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">Documentation</a></li>
                <li><a href="https://github.com/IdcuqS07/Aura-Protocol-V.1" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">GitHub</a></li>
                <li><a href="/analytics" className="text-gray-400 hover:text-purple-400 transition">Analytics</a></li>
                <li><a href="/roadmap" className="text-gray-400 hover:text-purple-400 transition">Roadmap</a></li>
                <li><a href="https://amoy.polygonscan.com/address/0x3d586E681b12B07825F17Ce19B28e1F576a1aF89" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition">Contract</a></li>
              </ul>
            </div>
          </div>

          {/* Bottom Bar */}
          <div className="pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center">
            <p className="text-gray-400 text-sm mb-4 md:mb-0">
              &copy; 2025 Aura Protocol. Built with ❤️ on Polygon.
            </p>
            <div className="flex items-center space-x-6 text-sm">
              <a href="https://polygon.technology" target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-purple-400 transition flex items-center space-x-1">
                <span>Powered by</span>
                <span className="text-purple-400 font-bold">Polygon</span>
              </a>
              <span className="text-gray-600">•</span>
              <span className="text-gray-400">Amoy Testnet</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;
