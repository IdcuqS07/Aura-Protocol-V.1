import React from 'react';
import { Shield, Twitter, Github, Linkedin, Globe } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-slate-950/80 border-t border-purple-500/20 mt-20">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <div className="bg-gradient-to-r from-purple-600 to-blue-600 p-2 rounded-lg">
              <Shield className="w-5 h-5 text-white" />
            </div>
            <span className="text-lg font-bold text-white">Aura Protocol</span>
          </div>

          {/* Social Media */}
          <div className="flex items-center space-x-4">
            <a href="#" className="text-gray-400 hover:text-purple-400 transition">
              <Twitter className="w-5 h-5" />
            </a>
            <a href="#" className="text-gray-400 hover:text-purple-400 transition">
              <Github className="w-5 h-5" />
            </a>
            <a href="#" className="text-gray-400 hover:text-purple-400 transition">
              <Linkedin className="w-5 h-5" />
            </a>
            <a href="#" className="text-gray-400 hover:text-purple-400 transition">
              <Globe className="w-5 h-5" />
            </a>
          </div>

          {/* Copyright */}
          <div className="text-gray-400 text-sm">
            © 2024 Aura Protocol. All rights reserved.
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;