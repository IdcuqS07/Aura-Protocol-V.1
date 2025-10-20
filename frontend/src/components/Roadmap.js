import React from 'react';
import { CheckCircle } from 'lucide-react';

const Roadmap = () => {
  const roadmap = [
    {
      wave: 'Wave 1',
      title: 'Foundation',
      status: 'Live',
      items: ['Proof of Uniqueness', 'ZK Identity Layer', 'Civic & Worldcoin Integration', 'ZK-ID Badge Launch']
    },
    {
      wave: 'Wave 2',
      title: 'ZK Credit Passport',
      status: 'In Progress',
      items: ['Credit Passport NFT', 'Proof-as-a-Service API', 'Analytics Dashboard', 'Premium Features']
    },
    {
      wave: 'Wave 3',
      title: 'Expansion',
      status: 'Coming Soon',
      items: ['Cross-Chain Layer (AuraX)', 'AI Risk Oracle', 'Reputation DAO', 'Multi-Chain Support']
    }
  ];

  return (
    <div className="min-h-screen pt-16 px-4 py-20">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-16 fade-in">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4">Roadmap</h1>
          <p className="text-gray-400 text-lg">Journey to become Polygon's Trust Layer</p>
        </div>
        <div className="grid md:grid-cols-3 gap-8">
          {roadmap.map((phase, index) => (
            <div
              key={index}
              className="p-8 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10 card-hover"
              data-testid={`roadmap-phase-${index}`}
            >
              <div className="flex items-center justify-between mb-4">
                <span className="text-purple-400 font-semibold">{phase.wave}</span>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                  phase.status === 'Live' ? 'bg-green-500/20 text-green-400' :
                  phase.status === 'In Progress' ? 'bg-blue-500/20 text-blue-400' :
                  'bg-gray-500/20 text-gray-400'
                }`}>
                  {phase.status}
                </span>
              </div>
              <h3 className="text-2xl font-bold text-white mb-4">{phase.title}</h3>
              <ul className="space-y-3">
                {phase.items.map((item, i) => (
                  <li key={i} className="flex items-start text-gray-300">
                    <CheckCircle className="w-5 h-5 text-purple-400 mr-2 flex-shrink-0 mt-0.5" />
                    <span className="text-sm">{item}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Roadmap;
