#!/usr/bin/env python3
# ============================================
# JETYXRAM - AutoFram Marshmellow Edition
# Versi: 4.0 (dengan AI Frame Generator)
# ============================================

import os
import sys
import time
import logging
import subprocess
import json
import random
import hashlib
import pickle
from datetime import datetime, timedelta
from threading import Thread, Lock
from pathlib import Path
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Union
import base64
import zlib

# ========== MARSHMELLOW CORE ==========
class MarshmellowCore:
    """Inti dari AutoFram Marshmellow - Sistem Frame Otomatis"""
    
    def __init__(self):
        self.frames = {}
        self.templates = {}
        self.patterns = {}
        self.lock = Lock()
        self.cache = {}
        self.frame_history = []
        self.max_history = 1000
        
        # Framework marshmellow
        self.framework = {
            'soft': True,        # Fleksibel
            'fluffy': True,      # Mengembang
            'sticky': False,     # Tidak lengket
            'meltable': True,    # Bisa berubah
            'layers': 7,         # 7 lapisan
            'sweetness': 100     # Level manis
        }
        
        self.init_templates()
        
    def init_templates(self):
        """Template dasar marshmellow"""
        self.templates = {
            'data_frame': {
                'type': 'structure',
                'layers': ['core', 'meta', 'data', 'validation', 'cache', 'log', 'backup'],
                'auto_expand': True,
                'compression': 'zlib',
                'encryption': False
            },
            'process_frame': {
                'type': 'process',
                'stages': ['init', 'prepare', 'execute', 'validate', 'finalize'],
                'retry': 3,
                'timeout': 300,
                'priority': 5
            },
            'network_frame': {
                'type': 'network',
                'protocols': ['http', 'websocket', 'grpc'],
                'endpoints': [],
                'load_balance': 'round_robin',
                'timeout': 30
            },
            'ai_frame': {
                'type': 'intelligence',
                'model': 'marshmellow_ai',
                'learning': True,
                'predictions': [],
                'accuracy': 0.85
            }
        }
    
    def create_frame(self, name: str, frame_type: str = 'data_frame', **kwargs) -> Dict:
        """Buat frame baru dengan pola marshmellow"""
        with self.lock:
            frame_id = self.generate_frame_id(name)
            
            # Ambil template
            template = self.templates.get(frame_type, self.templates['data_frame']).copy()
            
            # Buat frame
            frame = {
                'id': frame_id,
                'name': name,
                'type': frame_type,
                'created': datetime.now().isoformat(),
                'updated': datetime.now().isoformat(),
                'layers': self.build_layers(template),
                'data': kwargs.get('data', {}),
                'metadata': {
                    'version': '4.0',
                    'framework': 'marshmellow',
                    'softness': kwargs.get('softness', 0.8),
                    'fluffiness': kwargs.get('fluffiness', 0.9),
                    'state': 'active'
                },
                'hooks': {
                    'on_create': [],
                    'on_update': [],
                    'on_delete': [],
                    'on_expand': []
                },
                'relationships': [],
                'cache': {},
                'history': []
            }
            
            # Tambahkan ke koleksi
            self.frames[frame_id] = frame
            self.frame_history.append({
                'action': 'create',
                'frame_id': frame_id,
                'timestamp': datetime.now().isoformat()
            })
            
            # Auto-expand jika diperlukan
            if template.get('auto_expand', False):
                self.expand_frame(frame_id)
            
            self.log(f"🆕 Frame created: {name} ({frame_id})")
            return frame
    
    def build_layers(self, template: Dict) -> Dict:
        """Bangun lapisan marshmellow"""
        layers = {}
        layer_names = template.get('layers', ['core', 'data', 'meta'])
        
        for layer_name in layer_names:
            layers[layer_name] = {
                'data': {},
                'timestamp': datetime.now().isoformat(),
                'checksum': self.generate_checksum(layer_name),
                'status': 'active'
            }
        
        return layers
    
    def generate_frame_id(self, name: str) -> str:
        """Generate ID unik untuk frame"""
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S%f')
        random_part = random.randint(1000, 9999)
        hash_part = hashlib.md5(f"{name}{timestamp}".encode()).hexdigest()[:8]
        return f"MF-{timestamp}-{random_part}-{hash_part}"
    
    def generate_checksum(self, data: str) -> str:
        """Generate checksum untuk validasi"""
        return hashlib.sha256(data.encode()).hexdigest()[:16]
    
    def expand_frame(self, frame_id: str, layers: int = None):
        """Expand frame dengan lapisan baru (seperti marshmellow mengembang)"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            current_layers = len(frame['layers'])
            
            if layers is None:
                layers = self.framework['layers']
            
            new_layers = max(0, layers - current_layers)
            
            for i in range(new_layers):
                layer_name = f"layer_{current_layers + i + 1}"
                frame['layers'][layer_name] = {
                    'data': {},
                    'timestamp': datetime.now().isoformat(),
                    'checksum': self.generate_checksum(f"{frame_id}{layer_name}"),
                    'status': 'expanded',
                    'expansion_factor': 1.5 ** (i + 1)
                }
            
            frame['updated'] = datetime.now().isoformat()
            frame['metadata']['expanded_layers'] = len(frame['layers'])
            
            self.log(f"📈 Frame expanded: {frame['name']} -> {len(frame['layers'])} layers")
            return True
    
    def compress_frame(self, frame_id: str) -> bool:
        """Kompres frame (seperti marshmellow dipadatkan)"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            
            # Kompres data
            for layer_name, layer_data in frame['layers'].items():
                if isinstance(layer_data, dict):
                    json_str = json.dumps(layer_data)
                    compressed = zlib.compress(json_str.encode())
                    frame['layers'][layer_name] = {
                        'compressed': True,
                        'data': base64.b64encode(compressed).decode(),
                        'original_size': len(json_str),
                        'compressed_size': len(compressed)
                    }
            
            frame['metadata']['compressed'] = True
            frame['updated'] = datetime.now().isoformat()
            
            self.log(f"🗜️ Frame compressed: {frame['name']}")
            return True
    
    def decompress_frame(self, frame_id: str) -> bool:
        """Dekompres frame"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            
            for layer_name, layer_data in frame['layers'].items():
                if isinstance(layer_data, dict) and layer_data.get('compressed', False):
                    compressed = base64.b64decode(layer_data['data'])
                    decompressed = zlib.decompress(compressed)
                    frame['layers'][layer_name] = json.loads(decompressed.decode())
            
            frame['metadata']['compressed'] = False
            frame['updated'] = datetime.now().isoformat()
            
            self.log(f"📦 Frame decompressed: {frame['name']}")
            return True
    
    def melt_frame(self, frame_id: str, temperature: int = 50) -> Dict:
        """Lelehkan frame (ubah struktur)"""
        with self.lock:
            if frame_id not in self.frames:
                return None
            
            frame = self.frames[frame_id]
            
            # Simulasi pelelehan
            melted_data = {
                'original_id': frame_id,
                'melted_at': datetime.now().isoformat(),
                'temperature': temperature,
                'original_name': frame['name'],
                'layers_count': len(frame['layers']),
                'melted_data': {}
            }
            
            # Transformasi data
            for layer_name, layer_data in frame['layers'].items():
                melted_data['melted_data'][layer_name] = {
                    'melted': True,
                    'data': layer_data,
                    'viscosity': temperature / 100
                }
            
            # Simpan ke cache
            self.cache[f"melted_{frame_id}"] = melted_data
            
            # Update frame
            frame['metadata']['melted'] = True
            frame['metadata']['melt_temperature'] = temperature
            frame['updated'] = datetime.now().isoformat()
            
            self.log(f"🔥 Frame melted: {frame['name']} at {temperature}°C")
            return melted_data
    
    def freeze_frame(self, frame_id: str) -> bool:
        """Bekukan frame (jadikan immutable)"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            frame['metadata']['frozen'] = True
            frame['metadata']['frozen_at'] = datetime.now().isoformat()
            frame['updated'] = datetime.now().isoformat()
            
            self.log(f"❄️ Frame frozen: {frame['name']}")
            return True
    
    def auto_fram_generator(self, source_data: Any, pattern: str = 'auto') -> Dict:
        """Auto generate frame dari data apapun"""
        self.log(f"🤖 AutoFram generating from {type(source_data).__name__}")
        
        # Deteksi tipe data
        data_type = self.detect_data_type(source_data)
        
        # Pilih template sesuai tipe
        template_map = {
            'dict': 'data_frame',
            'list': 'process_frame',
            'str': 'ai_frame',
            'int': 'data_frame',
            'float': 'data_frame',
            'bytes': 'network_frame',
            'object': 'data_frame'
        }
        
        frame_type = template_map.get(data_type, 'data_frame')
        
        # Generate nama unik
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        name = f"autoframe_{data_type}_{timestamp}"
        
        # Buat frame dengan data
        frame = self.create_frame(name, frame_type, data={'source': source_data, 'type': data_type})
        
        # Tambahkan pattern
        if pattern != 'auto':
            self.apply_pattern(frame['id'], pattern)
        
        # Auto-expand jika data besar
        if self.estimate_size(source_data) > 1000:
            self.expand_frame(frame['id'], layers=10)
        
        # Optimasi
        self.optimize_frame(frame['id'])
        
        return frame
    
    def detect_data_type(self, data: Any) -> str:
        """Deteksi tipe data dengan AI sederhana"""
        if isinstance(data, dict):
            return 'dict'
        elif isinstance(data, list):
            return 'list'
        elif isinstance(data, str):
            return 'str'
        elif isinstance(data, (int, float)):
            return 'number'
        elif isinstance(data, bytes):
            return 'bytes'
        else:
            return 'object'
    
    def estimate_size(self, data: Any) -> int:
        """Estimasi ukuran data"""
        try:
            return len(json.dumps(data))
        except:
            return len(str(data))
    
    def apply_pattern(self, frame_id: str, pattern_name: str) -> bool:
        """Terapkan pattern ke frame"""
        patterns = {
            'crystal': {'structure': 'crystalline', 'layers': 12, 'density': 'high'},
            'cloud': {'structure': 'amorphous', 'layers': 5, 'density': 'low'},
            'bubble': {'structure': 'cellular', 'layers': 8, 'density': 'medium'},
            'spiral': {'structure': 'helical', 'layers': 15, 'density': 'medium'},
            'star': {'structure': 'radial', 'layers': 10, 'density': 'high'},
            'web': {'structure': 'network', 'layers': 6, 'density': 'low'},
            'lattice': {'structure': 'grid', 'layers': 9, 'density': 'high'},
            'default': {'structure': 'random', 'layers': 7, 'density': 'medium'}
        }
        
        pattern = patterns.get(pattern_name, patterns['default'])
        
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            frame['metadata']['pattern'] = pattern_name
            frame['metadata']['structure'] = pattern['structure']
            
            # Sesuaikan layers dengan pattern
            if pattern['layers'] > len(frame['layers']):
                self.expand_frame(frame_id, pattern['layers'])
            
            self.log(f"🎨 Pattern '{pattern_name}' applied to {frame['name']}")
            return True
    
    def optimize_frame(self, frame_id: str) -> bool:
        """Optimasi frame"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            
            # Optimasi: Hapus duplikasi
            seen = set()
            for layer_name in list(frame['layers'].keys()):
                if layer_name in seen:
                    del frame['layers'][layer_name]
                seen.add(layer_name)
            
            # Optimasi: Kompresi otomatis
            if len(json.dumps(frame)) > 10000:
                self.compress_frame(frame_id)
            
            frame['metadata']['optimized'] = True
            frame['updated'] = datetime.now().isoformat()
            
            self.log(f"⚡ Frame optimized: {frame['name']}")
            return True
    
    def merge_frames(self, frame_ids: List[str]) -> Dict:
        """Gabungkan beberapa frame menjadi satu (marshmallow merge)"""
        merged = {
            'id': f"MF-MERGED-{datetime.now().strftime('%Y%m%d%H%M%S')}",
            'name': f"merged_{'_'.join(frame_ids[:3])}",
            'type': 'merged',
            'created': datetime.now().isoformat(),
            'source_frames': frame_ids,
            'layers': {},
            'metadata': {
                'merged_at': datetime.now().isoformat(),
                'source_count': len(frame_ids),
                'framework': 'marshmellow_merged'
            }
        }
        
        with self.lock:
            for fid in frame_ids:
                if fid in self.frames:
                    source = self.frames[fid]
                    for layer_name, layer_data in source['layers'].items():
                        if layer_name not in merged['layers']:
                            merged['layers'][layer_name] = {
                                'data': {},
                                'source': fid,
                                'timestamp': datetime.now().isoformat()
                            }
                        merged['layers'][layer_name]['data'][fid] = layer_data
            
            # Simpan frame gabungan
            merged_id = merged['id']
            self.frames[merged_id] = merged
            
            self.log(f"🧩 Frames merged: {len(frame_ids)} -> {merged_id}")
            return merged
    
    def log(self, message: str):
        """Internal logging"""
        print(message)
    
    def get_frame_info(self, frame_id: str) -> Dict:
        """Dapatkan info frame"""
        if frame_id in self.frames:
            return {
                'exists': True,
                'name': self.frames[frame_id]['name'],
                'type': self.frames[frame_id]['type'],
                'layers': len(self.frames[frame_id]['layers']),
                'created': self.frames[frame_id]['created'],
                'metadata': self.frames[frame_id]['metadata']
            }
        return {'exists': False}
    
    def list_frames(self) -> List[str]:
        """List semua frame"""
        return list(self.frames.keys())
    
    def delete_frame(self, frame_id: str) -> bool:
        """Hapus frame"""
        with self.lock:
            if frame_id in self.frames:
                name = self.frames[frame_id]['name']
                del self.frames[frame_id]
                self.log(f"🗑️ Frame deleted: {name}")
                return True
        return False
    
    def backup_frames(self) -> str:
        """Backup semua frame"""
        backup_file = f"marshmellow_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(backup_file, 'w') as f:
            json.dump({
                'timestamp': datetime.now().isoformat(),
                'frame_count': len(self.frames),
                'frames': self.frames,
                'history': self.frame_history[-100:]
            }, f, indent=2)
        self.log(f"💾 Backup saved: {backup_file}")
        return backup_file
    
    def restore_frames(self, backup_file: str) -> bool:
        """Restore frame dari backup"""
        try:
            with open(backup_file, 'r') as f:
                data = json.load(f)
            
            with self.lock:
                self.frames = data['frames']
                self.frame_history = data['history']
            
            self.log(f"♻️ Restored {len(self.frames)} frames from {backup_file}")
            return True
        except Exception as e:
            self.log(f"❌ Restore failed: {e}")
            return False


# ========== INTEGRASI KE JETYXRAM ==========
class JetyxFram(MarshmellowCore):
    """JetyxFram dengan AutoFram Marshmellow"""
    
    def __init__(self):
        super().__init__()
        self.name = "JetyxFram"
        self.version = "4.0-Marshmellow"
        self.running = True
        self.log_file = "jetyxfram.log"
        self.config_file = "jetyxfram.json"
        
        self.setup_logging()
        self.load_config()
        self.init_marshmellow_features()
        
        self.log(f"🍬 {self.name} v{self.version} - AutoFram Marshmellow Edition")
        self.log(f"📊 {len(self.templates)} templates loaded")
        self.log(f"🧠 Marshmellow AI ready")
    
    def setup_logging(self):
        """Setup logging"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - JetyxFram - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(self.log_file),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger('JetyxFram')
    
    def load_config(self):
        """Load konfigurasi"""
        default_config = {
            'marshmellow': {
                'auto_expand': True,
                'max_layers': 20,
                'compression': True,
                'auto_backup': True,
                'backup_interval': 3600,
                'patterns': ['crystal', 'cloud', 'bubble', 'spiral']
            },
            'auto_fram': {
                'enabled': True,
                'detection': 'ai',
                'min_data_size': 100,
                'max_auto_frames': 1000
            }
        }
        
        if Path(self.config_file).exists():
            with open(self.config_file, 'r') as f:
                self.config = json.load(f)
        else:
            self.config = default_config
            self.save_config()
    
    def save_config(self):
        """Simpan config"""
        with open(self.config_file, 'w') as f:
            json.dump(self.config, f, indent=4)
    
    def init_marshmellow_features(self):
        """Inisialisasi fitur marshmellow"""
        # Load patterns dari config
        for pattern in self.config['marshmellow']['patterns']:
            if pattern not in self.patterns:
                self.patterns[pattern] = {
                    'loaded': True,
                    'timestamp': datetime.now().isoformat()
                }
        
        # Auto-backup thread
        if self.config['marshmellow']['auto_backup']:
            Thread(target=self.auto_backup_loop, daemon=True).start()
    
    def auto_backup_loop(self):
        """Loop backup otomatis"""
        while self.running:
            time.sleep(self.config['marshmellow']['backup_interval'])
            self.backup_frames()
            self.log("🔄 Auto-backup completed")
    
    # ========== AUTOFRAM SMART DETECTION ==========
    def smart_auto_fram(self, data: Any, context: str = 'auto') -> Dict:
        """AutoFram dengan AI detection"""
        self.log(f"🧠 Smart AutoFram triggered: {context}")
        
        # Analisis data
        analysis = self.analyze_data(data)
        
        # Pilih strategi
        if analysis['complexity'] > 0.7:
            # Data kompleks -> banyak layers
            frame = self.auto_fram_generator(data, pattern='crystal')
            self.expand_frame(frame['id'], layers=12)
        elif analysis['complexity'] > 0.4:
            # Data medium
            frame = self.auto_fram_generator(data, pattern='bubble')
            self.expand_frame(frame['id'], layers=8)
        else:
            # Data sederhana
            frame = self.auto_fram_generator(data, pattern='cloud')
        
        # Tambahkan metadata AI
        frame['metadata']['ai_analysis'] = analysis
        frame['metadata']['context'] = context
        
        self.log(f"✅ Smart AutoFram created: {frame['name']} (complexity: {analysis['complexity']:.2f})")
        return frame
    
    def analyze_data(self, data: Any) -> Dict:
        """Analisis data dengan AI sederhana"""
        analysis = {
            'type': type(data).__name__,
            'size': self.estimate_size(data),
            'complexity': 0.0,
            'structure': 'unknown',
            'patterns': []
        }
        
        if isinstance(data, dict):
            analysis['complexity'] = min(1.0, len(data) / 50)
            analysis['structure'] = 'dictionary'
            analysis['patterns'] = list(data.keys())[:5]
        elif isinstance(data, list):
            analysis['complexity'] = min(1.0, len(data) / 100)
            analysis['structure'] = 'list'
            if len(data) > 0 and isinstance(data[0], dict):
                analysis['complexity'] = min(1.0, analysis['complexity'] + 0.3)
        elif isinstance(data, str):
            analysis['complexity'] = min(1.0, len(data) / 1000)
            analysis['structure'] = 'string'
        elif isinstance(data, (int, float)):
            analysis['complexity'] = 0.1
            analysis['structure'] = 'number'
        
        return analysis
    
    # ========== MARSHMELLOW COMMANDS ==========
    def marshmellow_command(self, command: str, *args, **kwargs):
        """Command interface untuk marshmellow"""
        commands = {
            'create': self.create_frame,
            'expand': self.expand_frame,
            'compress': self.compress_frame,
            'decompress': self.decompress_frame,
            'melt': self.melt_frame,
            'freeze': self.freeze_frame,
            'merge': self.merge_frames,
            'optimize': self.optimize_frame,
            'backup': self.backup_frames,
            'restore': self.restore_frames,
            'list': self.list_frames,
            'delete': self.delete_frame,
            'info': self.get_frame_info,
            'auto': self.smart_auto_fram,
            'pattern': self.apply_pattern
        }
        
        if command in commands:
            result = commands[command](*args, **kwargs)
            self.log(f"🎯 Command '{command}' executed")
            return result
        else:
            self.log(f"❌ Unknown command: {command}")
            return None
    
    # ========== MAIN LOOP ==========
    def run(self):
        """Main loop dengan AutoFram"""
        self.log(f"🚀 {self.name} v{self.version} starting...")
        
        # Demo AutoFram
        demo_data = {
            'users': [
                {'name': 'Alice', 'age': 30, 'city': 'NYC'},
                {'name': 'Bob', 'age': 25, 'city': 'LA'},
                {'name': 'Charlie', 'age': 35, 'city': 'Chicago'}
            ],
            'settings': {
                'theme': 'dark',
                'notifications': True,
                'language': 'en'
            },
            'stats': {
                'total_users': 1000,
                'active_users': 750,
                'revenue': 50000
            }
        }
        
        # AutoFram data demo
        frame = self.smart_auto_fram(demo_data, context='initialization')
        
        # Expand frame
        self.expand_frame(frame['id'], layers=10)
        
        # Apply pattern
        self.apply_pattern(frame['id'], 'crystal')
        
        # Show status
        self.log(f"📊 Frame status: {self.get_frame_info(frame['id'])}")
        
        # Main loop
        counter = 0
        while self.running:
            try:
                counter += 1
                self.log(f"🔄 {self.name} running... (iteration {counter})")
                
                # AutoFram baru setiap 5 iterasi
                if counter % 5 == 0:
                    sample_data = {
                        'timestamp': datetime.now().isoformat(),
                        'counter': counter,
                        'random': random.random(),
                        'data': f"sample_{counter}"
                    }
                    self.smart_auto_fram(sample_data, context=f'iteration_{counter}')
                
                # Backup setiap 10 iterasi
                if counter % 10 == 0:
                    self.backup_frames()
                
                time.sleep(10)  # Interval
                
            except KeyboardInterrupt:
                self.log("🛑 Stopping...")
                break
            except Exception as e:
                self.log(f"❌ Error: {e}")
                time.sleep(5)
        
        self.log("👋 JetyxFram stopped")


# ========== CLI ==========
def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='JetyxFram Marshmellow Edition')
    parser.add_argument('--start', action='store_true', help='Start service')
    parser.add_argument('--stop', action='store_true', help='Stop service')
    parser.add_argument('--status', action='store_true', help='Check status')
    parser.add_argument('--auto', action='store_true', help='Run AutoFram on data')
    parser.add_argument('--data', type=str, help='Data untuk AutoFram (JSON)')
    parser.add_argument('--command', type=str, help='Marshmellow command')
    parser.add_argument('--args', nargs='*', help='Command arguments')
    parser.add_argument('--demo', action='store_true', help='Run demo')
    
    args = parser.parse_args()
    
    app = JetyxFram()
    
    if args.demo:
        # Demo AutoFram
        test_data = {
            'project': 'JetyxFram Demo',
            'version': '4.0',
            'features': ['AutoFram', 'Marshmellow', 'AI Detection'],
            'stats': {'frames': 0, 'layers': 0}
        }
        frame = app.smart_auto_fram(test_data, context='demo')
        print(f"✅ Demo frame created: {frame['id']}")
        print(f"📊 Info: {app.get_frame_info(frame['id'])}")
        return
    
    if args.auto and args.data:
        try:
            data = json.loads(args.data)
            frame = app.smart_auto_fram(data, context='cli')
            print(json.dumps(frame, indent=2))
        except:
            print("❌ Invalid JSON data")
        return
    
    if args.command:
        result = app.marshmellow_command(args.command, *(args.args or []))
        print(json.dumps(result, indent=2) if result else "Command executed")
        return
    
    if args.start:
        app.run()
    elif args.stop:
        app.running = False
        print("Stopping...")
    elif args.status:
        print(f"🔍 {app.name} status:")
        print(f"  Version: {app.version}")
        print(f"  Frames: {len(app.frames)}")
        print(f"  Templates: {len(app.templates)}")
        print(f"  Running: {app.running}")
        if app.frames:
            print("\n📋 Last 5 frames:")
            for fid in list(app.frames.keys())[-5:]:
                info = app.get_frame_info(fid)
                print(f"  - {info['name']} ({info['layers']} layers)")
    else:
        # Default: jalankan dengan demo
        app.run()


if __name__ == "__main__":
    main()