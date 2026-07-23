#!/usr/bin/env python3
# ============================================
# JETYXRAM - AutoFram Marshmellow Edition v5.1
# FIXED: Anti-Jitter & Smooth Performance
# ============================================

import os
import sys
import time
import json
import random
import hashlib
import zlib
import base64
import threading
from datetime import datetime
from typing import Any, Dict, List, Optional, Union
from collections import deque
import logging

# ========== KONFIGURASI ANTI-JITTER ==========
CONFIG = {
    'auto_expand': True,
    'max_layers': 20,
    'compression_threshold': 50000,  # Ditingkatkan (50KB)
    'backup_interval': 600,  # 10 menit
    'ai_confidence_threshold': 0.6,
    'patterns': ['crystal', 'cloud', 'bubble', 'spiral', 'web', 'lattice'],
    
    # 🔧 FIX: Anti-Jitter Settings
    'anti_jitter': {
        'enabled': True,
        'smooth_factor': 0.85,  # Faktor kehalusan (0-1)
        'max_delta': 0.1,       # Maksimum perubahan per iterasi
        'stabilize_cycles': 3,   # Siklus stabilisasi
        'cache_warmup': 5,       # Warmup cache sebelum digunakan
        'throttle_rate': 0.05,   # Rate limiting (detik)
        'jitter_tolerance': 0.01 # Toleransi jitter
    }
}

# ========== ANTI-JITTER DECORATOR ==========
def anti_jitter(func):
    """Decorator untuk mencegah jitter pada fungsi"""
    def wrapper(self, *args, **kwargs):
        if not CONFIG['anti_jitter']['enabled']:
            return func(self, *args, **kwargs)
        
        # Rate limiting
        time.sleep(CONFIG['anti_jitter']['throttle_rate'])
        
        # Stabilisasi
        for _ in range(CONFIG['anti_jitter']['stabilize_cycles']):
            result = func(self, *args, **kwargs)
            # Cek perubahan drastis
            if hasattr(self, '_last_result'):
                delta = self._calculate_delta(self._last_result, result)
                if delta > CONFIG['anti_jitter']['max_delta']:
                    # Smoothing
                    result = self._smooth_transition(self._last_result, result)
                    break
            self._last_result = result
        
        return result
    return wrapper

# ========== CORE MARSHMELLOW WITH ANTI-JITTER ==========
class MarshmellowCore:
    """Inti AutoFram dengan Anti-Jitter"""
    
    def __init__(self):
        self.frames = {}
        self.templates = {}
        self.patterns = {}
        self.cache = {}
        self.frame_history = deque(maxlen=1000)  # 🔧 FIX: Pakai deque
        self.lock = threading.Lock()
        self.running = True
        self._last_result = None
        self._stabilization_counter = 0
        
        # 🔧 FIX: Smooth cache
        self._cache_warmup = deque(maxlen=CONFIG['anti_jitter']['cache_warmup'])
        self._performance_history = deque(maxlen=50)
        
        # Framework properties
        self.properties = {
            'softness': 0.85,
            'fluffiness': 0.90,
            'layers': 7,
            'sweetness': 100,
            'elasticity': 0.75,
            'stability': 0.95  # 🔧 FIX: Stability increased
        }
        
        self._init_templates()
        self._init_patterns()
        self._start_auto_backup()
        self._start_health_monitor()  # 🔧 FIX: Health monitor
        
        print("🍬 Marshmellow Core initialized (Anti-Jitter ON)")
        print(f"📊 Templates: {len(self.templates)}")
        print(f"🎨 Patterns: {len(self.patterns)}")
        print(f"🛡️ Anti-Jitter: {CONFIG['anti_jitter']['enabled']}")
    
    # ========== ANTI-JITTER HELPERS ==========
    def _calculate_delta(self, old: Any, new: Any) -> float:
        """Hitung perubahan antara dua objek"""
        try:
            old_str = json.dumps(old, default=str)
            new_str = json.dumps(new, default=str)
            
            # Hitung perbedaan
            diff = 0
            for i, (a, b) in enumerate(zip(old_str, new_str)):
                if a != b:
                    diff += 1
                if i > 1000:  # Batasi perhitungan
                    break
            
            return diff / max(len(old_str), len(new_str), 1)
        except:
            return 1.0  # Default jika error
    
    def _smooth_transition(self, old: Any, new: Any) -> Any:
        """Smoothing transisi untuk mencegah jitter"""
        factor = CONFIG['anti_jitter']['smooth_factor']
        
        if isinstance(old, dict) and isinstance(new, dict):
            smoothed = {}
            all_keys = set(old.keys()) | set(new.keys())
            for key in all_keys:
                if key in old and key in new:
                    if isinstance(old[key], (int, float)) and isinstance(new[key], (int, float)):
                        smoothed[key] = old[key] * factor + new[key] * (1 - factor)
                    elif isinstance(old[key], dict) and isinstance(new[key], dict):
                        smoothed[key] = self._smooth_transition(old[key], new[key])
                    else:
                        smoothed[key] = new[key]
                elif key in old:
                    smoothed[key] = old[key] * factor
                else:
                    smoothed[key] = new[key] * (1 - factor)
            return smoothed
        elif isinstance(old, list) and isinstance(new, list):
            min_len = min(len(old), len(new))
            smoothed = []
            for i in range(min_len):
                if isinstance(old[i], (int, float)) and isinstance(new[i], (int, float)):
                    smoothed.append(old[i] * factor + new[i] * (1 - factor))
                else:
                    smoothed.append(new[i])
            # Tambahkan sisa
            if len(new) > len(old):
                smoothed.extend(new[len(old):])
            return smoothed
        else:
            return new
    
    def _warmup_cache(self, data: Any) -> Any:
        """Warmup cache untuk stabilitas"""
        self._cache_warmup.append(data)
        if len(self._cache_warmup) >= CONFIG['anti_jitter']['cache_warmup']:
            # Hitung rata-rata
            return self._average_data(list(self._cache_warmup))
        return data
    
    def _average_data(self, data_list: List) -> Any:
        """Hitung rata-rata dari multiple data untuk stabilitas"""
        if not data_list:
            return None
        
        # Coba rata-rata untuk numeric
        if all(isinstance(d, (int, float)) for d in data_list):
            return sum(data_list) / len(data_list)
        
        # Untuk dict, rata-rata per key
        if all(isinstance(d, dict) for d in data_list):
            avg_dict = {}
            all_keys = set().union(*[d.keys() for d in data_list])
            for key in all_keys:
                values = [d.get(key) for d in data_list if key in d]
                if values and all(isinstance(v, (int, float)) for v in values):
                    avg_dict[key] = sum(values) / len(values)
                elif values:
                    avg_dict[key] = values[-1]  # Ambil terakhir untuk non-numeric
            return avg_dict
        
        return data_list[-1]  # Default: ambil terakhir
    
    # ========== HEALTH MONITOR ==========
    def _start_health_monitor(self):
        """Monitor kesehatan sistem"""
        def monitor_loop():
            while self.running:
                time.sleep(30)  # Cek setiap 30 detik
                
                # Cek stabilitas
                if self.frames:
                    frame_ids = list(self.frames.keys())
                    if frame_ids:
                        # Cek perubahan drastis
                        stability_score = self._check_stability()
                        if stability_score < 0.5:
                            print(f"⚠️ Low stability detected: {stability_score:.2f}")
                            self._stabilize_system()
                
                # Cleanup cache
                if len(self.cache) > 100:
                    self._cleanup_cache()
        
        thread = threading.Thread(target=monitor_loop, daemon=True)
        thread.start()
    
    def _check_stability(self) -> float:
        """Cek stabilitas sistem"""
        if not self._performance_history:
            return 1.0
        
        # Hitung variasi
        values = [p.get('stability', 0) for p in self._performance_history]
        if len(values) < 2:
            return 1.0
        
        avg = sum(values) / len(values)
        variance = sum((v - avg) ** 2 for v in values) / len(values)
        
        # Stabilitas = 1 - variance
        return max(0, min(1, 1 - variance))
    
    def _stabilize_system(self):
        """Stabilkan sistem jika terjadi jitter"""
        print("🔄 Stabilizing system...")
        
        with self.lock:
            # Hapus frame yang tidak stabil
            unstable_frames = []
            for fid, frame in self.frames.items():
                if frame.get('metadata', {}).get('stability', 1) < 0.3:
                    unstable_frames.append(fid)
            
            for fid in unstable_frames:
                print(f"  🗑️ Removing unstable frame: {fid}")
                del self.frames[fid]
            
            # Reset cache
            self.cache.clear()
            self._cache_warmup.clear()
            
            print(f"✅ System stabilized (removed {len(unstable_frames)} unstable frames)")
    
    def _cleanup_cache(self):
        """Cleanup cache"""
        with self.lock:
            # Hapus cache lama
            cache_keys = list(self.cache.keys())
            if len(cache_keys) > 100:
                for key in cache_keys[:len(cache_keys) - 80]:
                    del self.cache[key]
                print(f"🧹 Cache cleaned: {len(self.cache)} entries remaining")
    
    # ========== INITIALIZATION ==========
    def _init_templates(self):
        """Inisialisasi template dasar"""
        self.templates = {
            'data': {
                'layers': ['core', 'meta', 'data', 'validation', 'cache', 'log', 'backup'],
                'auto_expand': True,
                'compression': 'zlib',
                'max_size': 10 * 1024 * 1024,
                'stability': 0.9  # 🔧 FIX: Stabilitas template
            },
            'process': {
                'layers': ['init', 'prepare', 'execute', 'validate', 'finalize'],
                'retry': 3,
                'timeout': 300,
                'priority': 5,
                'stability': 0.85
            },
            'network': {
                'layers': ['connection', 'auth', 'request', 'response', 'cache'],
                'protocols': ['http', 'websocket', 'grpc'],
                'timeout': 30,
                'stability': 0.8
            },
            'ai': {
                'layers': ['input', 'embedding', 'processing', 'output', 'feedback'],
                'model': 'marshmellow_ai',
                'learning_rate': 0.01,
                'accuracy': 0.85,
                'stability': 0.75
            },
            'smart': {
                'layers': ['sensor', 'analysis', 'decision', 'action', 'monitor'],
                'auto_adapt': True,
                'feedback_loop': True,
                'stability': 0.88
            }
        }
    
    def _init_patterns(self):
        """Inisialisasi pola struktur"""
        self.patterns = {
            'crystal': {
                'structure': 'crystalline',
                'layers': 12,
                'density': 'high',
                'stability': 0.95,
                'color': '#4A90D9',
                'jitter_resistance': 0.9  # 🔧 FIX: Resistance to jitter
            },
            'cloud': {
                'structure': 'amorphous',
                'layers': 5,
                'density': 'low',
                'stability': 0.60,
                'color': '#F5F5F5',
                'jitter_resistance': 0.6
            },
            'bubble': {
                'structure': 'cellular',
                'layers': 8,
                'density': 'medium',
                'stability': 0.75,
                'color': '#FF6B6B',
                'jitter_resistance': 0.7
            },
            'spiral': {
                'structure': 'helical',
                'layers': 15,
                'density': 'medium',
                'stability': 0.85,
                'color': '#51CF66',
                'jitter_resistance': 0.8
            },
            'web': {
                'structure': 'network',
                'layers': 6,
                'density': 'low',
                'stability': 0.70,
                'color': '#FCC419',
                'jitter_resistance': 0.65
            },
            'lattice': {
                'structure': 'grid',
                'layers': 9,
                'density': 'high',
                'stability': 0.90,
                'color': '#845EF7',
                'jitter_resistance': 0.85
            },
            'neural': {
                'structure': 'neural_network',
                'layers': 18,
                'density': 'very_high',
                'stability': 0.80,
                'color': '#E599F7',
                'jitter_resistance': 0.75
            }
        }
    
    def _start_auto_backup(self):
        """Start auto-backup thread"""
        def backup_loop():
            while self.running:
                time.sleep(CONFIG['backup_interval'])
                if self.frames:
                    self.backup_frames()
                    print("🔄 Auto-backup completed")
        
        thread = threading.Thread(target=backup_loop, daemon=True)
        thread.start()
    
    # ========== AUTOFRAM GENERATOR (FIXED) ==========
    @anti_jitter  # 🔧 FIX: Apply anti-jitter decorator
    def auto_fram(self, data: Any, context: str = 'auto', pattern: str = None) -> Dict:
        """
        AutoFram Generator - Buat frame dari data apapun
        (Dengan Anti-Jitter)
        """
        print(f"🤖 AutoFram generating from {type(data).__name__} (context: {context})")
        
        # 🔧 FIX: Warmup cache
        data = self._warmup_cache(data)
        
        # 1. Analisis data
        analysis = self._analyze_data(data)
        print(f"📊 Analysis: complexity={analysis['complexity']:.2f}, structure={analysis['structure']}")
        
        # 2. Pilih template terbaik
        template = self._select_template(analysis)
        print(f"📁 Selected template: {template}")
        
        # 3. Generate nama unik
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        name = f"autoframe_{analysis['type']}_{timestamp}"
        
        # 4. Buat frame
        frame = self._create_frame(name, template, data, analysis)
        
        # 5. Terapkan pattern
        if pattern is None:
            pattern = self._select_pattern(analysis)
        self._apply_pattern(frame['id'], pattern)
        
        # 6. 🔧 FIX: Auto-expand dengan stabilisasi
        if CONFIG['auto_expand'] and analysis['complexity'] > 0.6:
            layers = int(7 + (analysis['complexity'] * 10))
            self._expand_frame_stable(frame['id'], min(layers, CONFIG['max_layers']))
        
        # 7. Optimasi
        self._optimize_frame(frame['id'])
        
        # 8. Tambahkan metadata AI
        frame['metadata']['ai_analysis'] = analysis
        frame['metadata']['auto_generated'] = True
        frame['metadata']['generation_time'] = datetime.now().isoformat()
        frame['metadata']['stability'] = self.patterns.get(pattern, {}).get('stability', 0.8)
        frame['metadata']['jitter_resistance'] = self.patterns.get(pattern, {}).get('jitter_resistance', 0.7)
        
        # 9. 🔧 FIX: Record performance
        self._performance_history.append({
            'timestamp': datetime.now().isoformat(),
            'stability': frame['metadata']['stability'],
            'layers': len(frame['layers']),
            'complexity': analysis['complexity']
        })
        
        print(f"✅ AutoFram created: {frame['name']} ({frame['id']})")
        return frame
    
    # ========== ANALISIS DATA ==========
    def _analyze_data(self, data: Any) -> Dict:
        """Analisis data dengan AI sederhana"""
        analysis = {
            'type': type(data).__name__,
            'size': 0,
            'complexity': 0.0,
            'structure': 'unknown',
            'patterns_detected': [],
            'recommendations': []
        }
        
        if isinstance(data, dict):
            analysis['size'] = len(data)
            analysis['complexity'] = min(1.0, len(data) / 50)
            analysis['structure'] = 'dictionary'
            
            if len(data) > 5:
                analysis['patterns_detected'].append('complex_dict')
            if any(isinstance(v, (dict, list)) for v in data.values()):
                analysis['patterns_detected'].append('nested_structure')
                analysis['complexity'] = min(1.0, analysis['complexity'] + 0.3)
                
        elif isinstance(data, list):
            analysis['size'] = len(data)
            analysis['complexity'] = min(1.0, len(data) / 100)
            analysis['structure'] = 'list'
            
            if len(data) > 0 and isinstance(data[0], dict):
                analysis['patterns_detected'].append('list_of_objects')
                analysis['complexity'] = min(1.0, analysis['complexity'] + 0.3)
            if len(set(type(x).__name__ for x in data[:10])) > 3:
                analysis['patterns_detected'].append('mixed_types')
                
        elif isinstance(data, str):
            analysis['size'] = len(data)
            analysis['complexity'] = min(1.0, len(data) / 1000)
            analysis['structure'] = 'string'
            
            if len(data) > 100:
                analysis['patterns_detected'].append('long_text')
            if any(c in data for c in ['{', '[', '<']):
                analysis['patterns_detected'].append('structured_text')
                
        elif isinstance(data, (int, float)):
            analysis['size'] = 1
            analysis['complexity'] = 0.1
            analysis['structure'] = 'number'
            if data > 1000000:
                analysis['patterns_detected'].append('large_number')
                
        else:
            analysis['complexity'] = 0.3
            analysis['structure'] = 'object'
        
        # Rekomendasi
        if analysis['complexity'] > 0.7:
            analysis['recommendations'].append('use_crystal_pattern')
            analysis['recommendations'].append('expand_layers')
        elif analysis['complexity'] > 0.4:
            analysis['recommendations'].append('use_bubble_pattern')
        else:
            analysis['recommendations'].append('use_cloud_pattern')
        
        if 'nested_structure' in analysis['patterns_detected']:
            analysis['recommendations'].append('enable_deep_analysis')
            
        return analysis
    
    def _select_template(self, analysis: Dict) -> str:
        """Pilih template berdasarkan analisis"""
        if analysis['structure'] in ['dictionary', 'list'] and analysis['complexity'] > 0.5:
            return 'smart'
        elif 'structured_text' in analysis['patterns_detected']:
            return 'ai'
        elif analysis['structure'] == 'string' and analysis['size'] > 500:
            return 'data'
        elif analysis['structure'] == 'list' and analysis['size'] > 10:
            return 'process'
        else:
            return 'data'
    
    def _select_pattern(self, analysis: Dict) -> str:
        """Pilih pattern berdasarkan analisis"""
        if analysis['complexity'] > 0.8:
            return 'crystal'
        elif analysis['complexity'] > 0.5:
            return 'spiral'
        elif analysis['complexity'] > 0.3:
            return 'bubble'
        elif 'nested_structure' in analysis['patterns_detected']:
            return 'neural'
        else:
            return 'cloud'
    
    # ========== FRAME CREATION (FIXED) ==========
    def _create_frame(self, name: str, template: str, data: Any, analysis: Dict) -> Dict:
        """Buat frame baru dengan stabilitas"""
        with self.lock:
            frame_id = self._generate_id(name)
            template_data = self.templates.get(template, self.templates['data'])
            
            frame = {
                'id': frame_id,
                'name': name,
                'type': template,
                'created': datetime.now().isoformat(),
                'updated': datetime.now().isoformat(),
                'layers': self._build_layers(template_data),
                'data': {
                    'original': data,
                    'processed': self._preprocess_data(data),
                    'analysis': analysis
                },
                'metadata': {
                    'version': '5.1',  # 🔧 FIX: Version updated
                    'framework': 'marshmellow',
                    'template': template,
                    'state': 'active',
                    'auto_generated': True,
                    'stability': template_data.get('stability', 0.8),
                    'jitter_check': True  # 🔧 FIX: Jitter tracking
                },
                'cache': {},
                'relationships': [],
                'history': [{
                    'action': 'create',
                    'timestamp': datetime.now().isoformat()
                }]
            }
            
            self.frames[frame_id] = frame
            self.frame_history.append({
                'action': 'create',
                'frame_id': frame_id,
                'timestamp': datetime.now().isoformat()
            })
            
            return frame
    
    def _build_layers(self, template: Dict) -> Dict:
        """Bangun lapisan frame"""
        layers = {}
        layer_names = template.get('layers', ['core', 'data', 'meta'])
        
        for layer_name in layer_names:
            layers[layer_name] = {
                'data': {},
                'created': datetime.now().isoformat(),
                'checksum': self._generate_checksum(layer_name),
                'status': 'active',
                'depth': len(layers) + 1,
                'stability': 1.0  # 🔧 FIX: Initial stability
            }
        
        return layers
    
    def _generate_id(self, name: str) -> str:
        """Generate ID unik"""
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S%f')
        random_part = random.randint(1000, 9999)
        hash_part = hashlib.md5(f"{name}{timestamp}".encode()).hexdigest()[:8]
        return f"MF-{timestamp}-{random_part}-{hash_part}"
    
    def _generate_checksum(self, data: str) -> str:
        """Generate checksum"""
        return hashlib.sha256(data.encode()).hexdigest()[:16]
    
    def _preprocess_data(self, data: Any) -> Any:
        """Preprocess data dengan stabilisasi"""
        if isinstance(data, dict):
            cleaned = {}
            for k, v in data.items():
                if isinstance(v, (str, int, float, bool, list, dict)):
                    # 🔧 FIX: Stabilkan nilai numeric
                    if isinstance(v, (int, float)):
                        v = round(v, 4)  # Batasi presisi
                    cleaned[k] = v
            return cleaned
        return data
    
    # ========== PATTERN APPLICATION (FIXED) ==========
    def _apply_pattern(self, frame_id: str, pattern_name: str) -> bool:
        """Terapkan pola struktur dengan stabilisasi"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            pattern = self.patterns.get(pattern_name, self.patterns['cloud'])
            frame = self.frames[frame_id]
            
            # Update metadata
            frame['metadata']['pattern'] = pattern_name
            frame['metadata']['structure'] = pattern['structure']
            frame['metadata']['density'] = pattern['density']
            frame['metadata']['stability'] = pattern['stability']
            frame['metadata']['jitter_resistance'] = pattern.get('jitter_resistance', 0.7)
            
            # 🔧 FIX: Sesuaikan layers dengan stabilisasi
            if pattern['layers'] > len(frame['layers']):
                self._expand_frame_stable(frame_id, pattern['layers'])
            
            frame['updated'] = datetime.now().isoformat()
            frame['history'].append({
                'action': 'apply_pattern',
                'pattern': pattern_name,
                'timestamp': datetime.now().isoformat()
            })
            
            print(f"🎨 Pattern '{pattern_name}' applied to {frame['name']}")
            return True
    
    def _expand_frame_stable(self, frame_id: str, layers: int) -> bool:
        """Expand frame dengan stabilisasi (Anti-Jitter)"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            current_layers = len(frame['layers'])
            
            if layers <= current_layers:
                return True
            
            # 🔧 FIX: Expand bertahap (tidak langsung)
            for target in range(current_layers + 1, layers + 1):
                # Tambahkan layer dengan stabilisasi
                layer_name = f"layer_{target}"
                frame['layers'][layer_name] = {
                    'data': {},
                    'created': datetime.now().isoformat(),
                    'checksum': self._generate_checksum(f"{frame_id}{layer_name}"),
                    'status': 'stabilizing',  # 🔧 FIX: Status stabilisasi
                    'depth': target,
                    'expansion_factor': 1.0 + (0.1 * (target - current_layers)),
                    'stability': 0.9  # 🔧 FIX: Initial stability high
                }
                
                # 🔧 FIX: Jeda untuk stabilitas
                time.sleep(CONFIG['anti_jitter']['throttle_rate'])
                
                # Update status setelah stabil
                frame['layers'][layer_name]['status'] = 'active'
                frame['layers'][layer_name]['stability'] = 1.0
            
            frame['updated'] = datetime.now().isoformat()
            frame['metadata']['expanded_layers'] = len(frame['layers'])
            frame['metadata']['stability'] = min(1.0, frame['metadata'].get('stability', 1) + 0.05)
            
            print(f"📈 Frame expanded (stable): {frame['name']} -> {len(frame['layers'])} layers")
            return True
    
    # ========== COMPRESSION (FIXED) ==========
    def _compress_frame(self, frame_id: str) -> bool:
        """Kompres frame dengan stabilisasi"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            
            # 🔧 FIX: Backup data sebelum kompresi
            backup = json.dumps(frame['layers'], default=str)
            
            try:
                for layer_name, layer_data in frame['layers'].items():
                    if isinstance(layer_data, dict) and 'data' in layer_data:
                        json_str = json.dumps(layer_data['data'])
                        compressed = zlib.compress(json_str.encode())
                        frame['layers'][layer_name]['data'] = {
                            'compressed': True,
                            'data': base64.b64encode(compressed).decode(),
                            'original_size': len(json_str),
                            'compressed_size': len(compressed),
                            'stability_check': hashlib.md5(json_str.encode()).hexdigest()[:8]  # 🔧 FIX
                        }
                
                frame['metadata']['compressed'] = True
                frame['updated'] = datetime.now().isoformat()
                
                print(f"🗜️ Frame compressed: {frame['name']}")
                return True
                
            except Exception as e:
                # 🔧 FIX: Rollback jika error
                print(f"❌ Compression failed: {e}, rolling back...")
                frame['layers'] = json.loads(backup)
                return False
    
    def _optimize_frame(self, frame_id: str) -> bool:
        """Optimasi frame dengan stabilisasi"""
        with self.lock:
            if frame_id not in self.frames:
                return False
            
            frame = self.frames[frame_id]
            
            # 🔧 FIX: Check stability before optimization
            stability = frame['metadata'].get('stability', 0.8)
            if stability < 0.6:
                print(f"⚠️ Frame {frame['name']} stability too low, skipping optimization")
                return False
            
            # Estimasi ukuran
            try:
                size = len(json.dumps(frame))
                if size > CONFIG['compression_threshold']:
                    self._compress_frame(frame_id)
            except:
                pass
            
            # Hapus duplikasi
            seen = set()
            for layer_name in list(frame['layers'].keys()):
                if layer_name in seen:
                    del frame['layers'][layer_name]
                seen.add(layer_name)
            
            frame['metadata']['optimized'] = True
            frame['metadata']['optimized_at'] = datetime.now().isoformat()
            frame['updated'] = datetime.now().isoformat()
            
            print(f"⚡ Frame optimized: {frame['name']}")
            return True
    
    # ========== MANAJEMEN FRAME ==========
    def get_frame(self, frame_id: str) -> Optional[Dict]:
        """Dapatkan frame dengan stabilisasi cache"""
        # 🔧 FIX: Cache check
        if frame_id in self.cache:
            return self.cache[frame_id]
        
        frame = self.frames.get(frame_id)
        if frame:
            # 🔧 FIX: Cache dengan batas
            if len(self.cache) < 100:
                self.cache[frame_id] = frame
        
        return frame
    
    def list_frames(self) -> List[Dict]:
        """List semua frame"""
        return [
            {
                'id': fid,
                'name': f['name'],
                'type': f['type'],
                'layers': len(f['layers']),
                'created': f['created'],
                'pattern': f['metadata'].get('pattern', 'none'),
                'stability': f['metadata'].get('stability', 0.8)  # 🔧 FIX
            }
            for fid, f in self.frames.items()
        ]
    
    def delete_frame(self, frame_id: str) -> bool:
        """Hapus frame"""
        with self.lock:
            if frame_id in self.frames:
                name = self.frames[frame_id]['name']
                del self.frames[frame_id]
                # 🔧 FIX: Hapus dari cache juga
                if frame_id in self.cache:
                    del self.cache[frame_id]
                print(f"🗑️ Frame deleted: {name}")
                return True
        return False
    
    def merge_frames(self, frame_ids: List[str]) -> Dict:
        """Gabungkan beberapa frame dengan stabilisasi"""
        if len(frame_ids) < 2:
            return None
        
        # 🔧 FIX: Check stability before merge
        unstable = []
        for fid in frame_ids:
            if fid in self.frames:
                stability = self.frames[fid]['metadata'].get('stability', 0.8)
                if stability < 0.5:
                    unstable.append(fid)
        
        if unstable:
            print(f"⚠️ Skipping unstable frames: {unstable}")
            frame_ids = [fid for fid in frame_ids if fid not in unstable]
            if len(frame_ids) < 2:
                return None
        
        merged = {
            'id': f"MF-MERGED-{datetime.now().strftime('%Y%m%d%H%M%S')}",
            'name': f"merged_{'_'.join(fid[:8] for fid in frame_ids[:3])}",
            'type': 'merged',
            'created': datetime.now().isoformat(),
            'source_frames': frame_ids,
            'layers': {},
            'metadata': {
                'merged_at': datetime.now().isoformat(),
                'source_count': len(frame_ids),
                'framework': 'marshmellow_merged',
                'stability': 0.9  # 🔧 FIX: High initial stability
            },
            'cache': {},
            'relationships': frame_ids,
            'history': [{
                'action': 'merge',
                'sources': frame_ids,
                'timestamp': datetime.now().isoformat()
            }]
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
                                'created': datetime.now().isoformat(),
                                'stability': 0.9  # 🔧 FIX
                            }
                        merged['layers'][layer_name]['data'][fid] = layer_data
            
            merged_id = merged['id']
            self.frames[merged_id] = merged
            
            print(f"🧩 Frames merged: {len(frame_ids)} -> {merged_id}")
            return merged
    
    def backup_frames(self) -> str:
        """Backup semua frame"""
        backup_file = f"marshmellow_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        
        with open(backup_file, 'w') as f:
            json.dump({
                'timestamp': datetime.now().isoformat(),
                'version': '5.1',
                'frame_count': len(self.frames),
                'frames': self.frames,
                'history': list(self.frame_history)[-500:],
                'patterns': self.patterns,
                'config': CONFIG
            }, f, indent=2, default=str)
        
        print(f"💾 Backup saved: {backup_file}")
        return backup_file
    
    def restore_frames(self, backup_file: str) -> bool:
        """Restore dari backup"""
        try:
            with open(backup_file, 'r') as f:
                data = json.load(f)
            
            with self.lock:
                self.frames = data['frames']
                self.frame_history = deque(data.get('history', []), maxlen=1000)
            
            print(f"